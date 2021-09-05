// solhint-disable no-unused-vars
// SPDX-License-Identifier: agpl-3.0

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

/////////////////////////////////////////////////////
/// PLEASE DO NOT USE THIS CONTRACT IN PRODUCTION ///
/////////////////////////////////////////////////////

//  libraries
import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";

//  interfaces
import { ILido } from "../interfaces/lido/ILido.sol";
import { IStETH } from "../interfaces/lido/IStETH.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IAdapter } from "../interfaces/opty/defiAdapters/IAdapter.sol";
import { IUniswapV2Router02 } from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

import { IHarvestDeposit } from "../interfaces/harvest.finance/IHarvestDeposit.sol";
import { IHarvestFarm } from "../interfaces/harvest.finance/IHarvestFarm.sol";
import { IAdapterHarvestReward } from "../interfaces/opty/defiAdapters/IAdapterHarvestReward.sol";
import { IAdapterStaking } from "../interfaces/opty/defiAdapters/IAdapterStaking.sol";

/**
 * @title Adapter for Lido protocol
 * @author yodashiv
 * @dev Abstraction layer to Lido staking pool
 */

contract LidoAdapter is IAdapter {
    using SafeMath for uint256;

    /**
     * @notice Uniswap V2 router contract address
     */
    address public constant uniswapV2Router02 = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    /**
     * @notice Curve ETH/StETH pool  
     * Curve provides the best liquidity for ETH/StETH (as they are very close in price)
     * Liquidity is deeper also because of liquidity mining on Curve
     * https://blog.lido.fi/providing-steth-liquidity-via-curve-to-receive-rewards/  
     */
     address public constant curveETHStETHPool = address(0xDC24316b9AE028F1497c275EB9192a3Ea0f67022);

    /**
     * @notice This is the address for the LIDO staking contract
     * Note that this is a proxy contract 
     * https://docs.lido.fi/deployed-contracts
     */
    address payable public lidoAndStETHAddress = payable(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84);

    /**
     * @notice This is the address for the LDO governance token
     * This could serve as a reward token in the future
     */
    address public LdoGovernanceToken = address(0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32);

    // Referral address for Lido Staking
    address public lidoReferralAddress = address(0x862ac3F3F28ddC370d38E1F0219FF460Ea5d86A9);

    // The underlyingToken address is not needed as there is no such concept for lido staking
    // We use the 0 address as a dummy value when we need to pass underlyingToken as a parameter, 
    // but don't actually use it
    address public _noOperationUnderlyingToken = address(0);

    // This is the slippage percentage (in basis points) we can tolerate when selling stETH into the ETH/stETH curve pool
    uint256 public _maxSlippage = 100;

    /**
     * @inheritdoc IAdapter
     */
     // DONE
    function getDepositAllCodes(
        address payable _vault,
        address[] memory _underlyingTokens,
        address _liquidityPool
    ) public view override returns (bytes[] memory _codes) {
        uint256[] memory _amounts = new uint256[](1);
        // Full balance of the vault
        _amounts[0] = _vault.balance;
        return getDepositSomeCodes(_vault, _underlyingTokens, _liquidityPool, _amounts);
    }

    /**
     * @inheritdoc IAdapter
     */
    function getWithdrawAllCodes(
        address payable _vault,
        address[] memory _underlyingTokens,
        address _liquidityPool
    ) public view override returns (bytes[] memory _codes) {
        uint256 _redeemAmount = getLiquidityPoolTokenBalance(_vault, _noOperationUnderlyingToken, _liquidityPool);
        return getWithdrawSomeCodes(_vault, _underlyingTokens, _liquidityPool, _redeemAmount);
    }

    /**
     * @inheritdoc IAdapter
     */
    function getUnderlyingTokens(address _liquidityPool, address)
        public
        view
        override
        returns (address[] memory _underlyingTokens)
    {
        _underlyingTokens = new address[](1);
        _underlyingTokens[0] = IHarvestDeposit(_liquidityPool).underlying();
    }

    /**
     * @inheritdoc IAdapter
     */
    function calculateAmountInLPToken(
        address,
        address _liquidityPool,
        uint256 _depositAmount
    ) public view override returns (uint256) {
        return
            _depositAmount.mul(10**IHarvestDeposit(_liquidityPool).decimals()).div(
                IHarvestDeposit(_liquidityPool).getPricePerFullShare()
            );
    }

    /**
     * @inheritdoc IAdapter
     */
    function calculateRedeemableLPTokenAmount(
        address payable _vault,
        address _underlyingToken,
        address _liquidityPool,
        uint256 _redeemAmount
    ) public view override returns (uint256 _amount) {
        uint256 _liquidityPoolTokenBalance = getLiquidityPoolTokenBalance(_vault, _underlyingToken, _liquidityPool);
        uint256 _balanceInToken = getAllAmountInToken(_vault, _underlyingToken, _liquidityPool);
        // can have unintentional rounding errors
        _amount = (_liquidityPoolTokenBalance.mul(_redeemAmount)).div(_balanceInToken).add(1);
    }

    /**
     * @inheritdoc IAdapter
     */
    function isRedeemableAmountSufficient(
        address payable _vault,
        address _underlyingToken,
        address _liquidityPool,
        uint256 _redeemAmount
    ) public view override returns (bool) {
        uint256 _balanceInToken = getAllAmountInToken(_vault, _underlyingToken, _liquidityPool);
        return _balanceInToken >= _redeemAmount;
    }

    /**
     * @inheritdoc IAdapter
     */
    function canStake(address) public view override returns (bool) {
        return true;
    }

    /**
     * @inheritdoc IAdapter
     */
     // DONE
    function getDepositSomeCodes(
        address payable,
        address[] memory,
        address,
        uint256[] memory _amounts
    ) public view override returns (bytes[] memory _codes) {
        if (_amounts[0] > 0) {
            _codes = new bytes[](1);

            // The address argument is a referral address.
            // There is no amount parameter; the amount to deposit must be specified 
            // as the value of the message (msg.value).
            _codes[0] = abi.encode(lidoAndStETHAddress, abi.encodeWithSignature("submit(address)", lidoReferralAddress));
        }
    }

    /**
     * @inheritdoc IAdapter
     */
    // DONE
    // _amount is the amount in pooled ETH (not shares)
    function getWithdrawSomeCodes(
        address payable,
        address[] memory _underlyingTokens,
        address _liquidityPool,
        uint256 _amount
    ) public view override returns (bytes[] memory _codes) {
        if (_amount > 0) {
            _codes = new bytes[](2);
            // First, let's allow Curve to use our stETH 
            //TODO: Are there other parameters here? 
            _codes[0] = abi.encode(lidoAndStETHAddress, abi.encodeWithSignature("approve(address,uint256)", curveETHStETHPool, _amount));
            // Second, let's create the bytecode for actually exchanging stETH for ETH
            _codes[1] = abi.encode(curveETHStETHPool, 
                abi.encodeWithSignature("exchange(int128,int128,uint256,uint256)",
                1, // index of sTETH in curve pool (what we want to exchange)
                0, // "index" of ETH (it points to a burn address)
                _amount, // the amount of stETH that we want to sell into the pool
                _getMinAmountOfTokenAfterSwap(_amount) // specify max slippage
            ));
        }
    }

    function _getMinAmountOfTokenAfterSwap(uint256 _amountToSell) public view returns(uint256) {
        // 1% max slippage
        uint256 maxSlippage = _amountToSell.mul(_maxSlippage).div(10000);
        return _amountToSell.sub(maxSlippage);
    }

    /**
     * @inheritdoc IAdapter
     */
    function getPoolValue(address _liquidityPool, address) public view override returns (uint256) {
        return IHarvestDeposit(_liquidityPool).underlyingBalanceWithInvestment();
    }

    /**
     * @inheritdoc IAdapter
     */
    function getLiquidityPoolToken(address, address _liquidityPool) public view override returns (address) {
        return _liquidityPool;
    }

    /**
     * @inheritdoc IAdapter
     */
    function getAllAmountInToken(
        address payable _vault,
        address _underlyingToken,
        address _liquidityPool
    ) public view override returns (uint256) {
        return
            getSomeAmountInToken(
                _underlyingToken,
                _liquidityPool,
                getLiquidityPoolTokenBalance(_vault, _underlyingToken, _liquidityPool)
            );
    }

    /**
     * @inheritdoc IAdapter
     */
     // DONE
    function getLiquidityPoolTokenBalance(
        address payable _vault,
        address,
        address _liquidityPool
    ) public view override returns (uint256) {
        // If _liquidityPool is the LdoAndStEth address, 
        // This will get us the balance of ETH 
        // There is an internal concept of "shares" but we choose 
        // here not to break that abstraction barrier
        return IERC20(_liquidityPool).balanceOf(_vault);
    }

    /**
     * @inheritdoc IAdapter
     */
    function getSomeAmountInToken(
        address,
        address _liquidityPool,
        uint256 _liquidityPoolTokenAmount
    ) public view override returns (uint256) {
        if (_liquidityPoolTokenAmount > 0) {
            _liquidityPoolTokenAmount = _liquidityPoolTokenAmount
                .mul(IHarvestDeposit(_liquidityPool).getPricePerFullShare())
                .div(10**IHarvestDeposit(_liquidityPool).decimals());
        }
        return _liquidityPoolTokenAmount;
    }

    /**
     * Note that there is no reward token for staking on Lido currently, 
     * but the LDO governance token could serve as reward token in the future. 
     * Thus, we put the address of the LDO token here. 
     * @inheritdoc IAdapter
     */
     // DONE
    function getRewardToken(address) public view override returns (address) {
        return LdoGovernanceToken;
    }
}
