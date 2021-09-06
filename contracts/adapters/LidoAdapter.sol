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
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IAdapter } from "../interfaces/opty/defiAdapters/IAdapter.sol";

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

    // This is a burn address 
    address public burnAddress = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);


    // NOTE: The "LP Token" in this case are "shares". This is an internal bookkeeping mechanism that Lido uses
    // to determine how much ETH a user is eligible to withdraw
    // The "underlying token" is ETH, which does not have an address 

    /**
     * @inheritdoc IAdapter
     */
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
     // "Underlying" token is ETH which has no address, so we return the burn address
    function getUnderlyingTokens(address, address)
        public
        view
        override
        returns (address[] memory _underlyingTokens)
    {
        _underlyingTokens = new address[](1);
        _underlyingTokens[0] = burnAddress;
    }

    /**
     * @inheritdoc IAdapter
     */
    function calculateAmountInLPToken(
        address,
        address,
        uint256 _underlyingTokenAmount
    ) public view override returns (uint256) {
        return ILido(lidoAndStETHAddress).getSharesByPooledEth(_underlyingTokenAmount);
    }

    /**
     * @inheritdoc IAdapter
     */
    function calculateRedeemableLPTokenAmount(
        address payable,
        address,
        address,
        uint256 _redeemAmount
    ) public view override returns (uint256) {
        // There is no concept of redeemable LP tokens
        // Rewards are automatically added to a users balance (no need to redeem)
        // So let's just calculate the amount of ETH corresponds to _redeemAmount of shares
        return ILido(lidoAndStETHAddress).getPooledEthByShares(_redeemAmount);
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
        // You can't stake stETH into the Lido Protocol
        return false;
    }

    /**
     * @inheritdoc IAdapter
     */
    function getDepositSomeCodes(
        address payable,
        address[] memory,
        address,
        uint256[] memory _amounts
    ) public view override returns (bytes[] memory _codes) {
        if (_amounts[0] > 0) {
            _codes = new bytes[](1);
            _codes[0] = abi.encode(lidoAndStETHAddress, _amounts[0], abi.encodeWithSignature("submit(address)", lidoReferralAddress));
        }
    }

    /**
     * @inheritdoc IAdapter
     * @param _amount is the amount in shares
     */
    function getWithdrawSomeCodes(
        address payable,
        address[] memory,
        address,
        uint256 _amount
    ) public view override returns (bytes[] memory _codes) {
        if (_amount > 0) {
            uint256 _amountInStETH = ILido(lidoAndStETHAddress).getPooledEthByShares(_amount);
            _codes = new bytes[](2);
            // First, let's allow Curve to use our stETH 
            _codes[0] = abi.encode(lidoAndStETHAddress, 0, abi.encodeWithSignature("approve(address,uint256)", curveETHStETHPool, _amountInStETH));
            // Second, let's create the bytecode for actually exchanging stETH for ETH
            _codes[1] = abi.encode(curveETHStETHPool, 
                0, // send 0 as msg.value
                abi.encodeWithSignature("exchange(int128,int128,uint256,uint256)",
                    1, // index of sTETH in curve pool (what we want to exchange)
                    0, // "index" of ETH (it points to a burn address)
                    _amountInStETH, // the amount of stETH that we want to sell into the pool
                    _getMinAmountOfTokenAfterSwap(_amountInStETH) // specify max slippage
            ));
        }
    }

    /**
     * @param _amountToSell the amount of stETH to sell to Curve
     * Note that this assumes stETH & ETH are trading at a 1:1 ratio
     */
    function _getMinAmountOfTokenAfterSwap(uint256 _amountToSell) public view returns(uint256) {
        // 1% max slippage
        uint256 maxSlippage = _amountToSell.mul(_maxSlippage).div(10000);
        return _amountToSell.sub(maxSlippage);
    }

    /**
     * @inheritdoc IAdapter
     */
    function getPoolValue(address, address) public view override returns (uint256) {
        return IERC20(lidoAndStETHAddress).totalSupply();
    }

    /**
     * @inheritdoc IAdapter
     */
    function getLiquidityPoolToken(address, address) public view override returns (address) {
        return lidoAndStETHAddress;
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
    function getLiquidityPoolTokenBalance(
        address payable _vault,
        address,
        address
    ) public view override returns (uint256) {
        // This will return the number of shares owned by _vault
        return ILido(lidoAndStETHAddress).sharesOf(_vault);
    }

    /**
     * @inheritdoc IAdapter
     */
    function getSomeAmountInToken(
        address,
        address,
        uint256 _liquidityPoolTokenAmount
    ) public view override returns (uint256) {
        return ILido(lidoAndStETHAddress).getPooledEthByShares(_liquidityPoolTokenAmount);
    }

    /**
     * Note that there is no reward token for staking on Lido currently, 
     * but the LDO governance token could serve as reward token in the future. 
     * Thus, we put the address of the LDO token here. 
     * @inheritdoc IAdapter
     */
    function getRewardToken(address) public view override returns (address) {
        return LdoGovernanceToken;
    }
}
