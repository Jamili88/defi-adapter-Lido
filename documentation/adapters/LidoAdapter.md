## `LidoAdapter`



Abstraction layer to Lido staking pool


### `getDepositAllCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool) → bytes[] _codes` (public)



Get batch of function calls for depositing vault's full balance in underlying tokens in given liquidity pool


### `getWithdrawAllCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool) → bytes[] _codes` (public)

Get batch of function calls for redeeming full balance of lpTokens held in the vault


Redeem full `amount` of `liquidityPoolToken` and send the `underlyingToken` to the caller`


### `getUnderlyingTokens(address, address) → address[] _underlyingTokens` (public)

Get the underlying token addresses given the liquidity pool and/or lpToken


there are some defi pools which requires liqudiity pool and lpToken's address to return underlying token


### `calculateAmountInLPToken(address, address, uint256 _underlyingTokenAmount) → uint256` (public)



Returns the equivalent value of lpToken for given amount of underlying token


### `calculateRedeemableLPTokenAmount(address payable, address, address, uint256 _redeemAmount) → uint256` (public)



Returns the market value in underlying token of the shares in the specified liquidity pool


### `isRedeemableAmountSufficient(address payable _vault, address _underlyingToken, address _liquidityPool, uint256 _redeemAmount) → bool` (public)

Checks whether the vault has enough lpToken (+ rewards) to redeem for the specified amount of shares




### `canStake(address) → bool` (public)

Returns whether the protocol can stake lpToken




### `getDepositSomeCodes(address payable, address[], address, uint256[] _amounts) → bytes[] _codes` (public)



Get batch of function calls for depositing specified amount of underlying token in given liquidity pool


### `getWithdrawSomeCodes(address payable, address[], address, uint256 _amount) → bytes[] _codes` (public)

Get batch of function calls for redeeming specified amount of lpTokens held in the vault


Redeem specified `amount` of `liquidityPoolToken` and send the `underlyingToken` to the caller`


### `_getMinAmountOfTokenAfterSwap(uint256 _amountToSell) → uint256` (public)





### `getPoolValue(address, address) → uint256` (public)

Returns pool value in underlying token (for all adapters except Curve for which the poolValue is
in US dollar) for the given liquidity pool and underlyingToken


poolValue can be in US dollar for protocols like Curve if explicitly specified, underlyingToken otherwise
for protocols like Compound etc.


### `getLiquidityPoolToken(address, address) → address` (public)

Get the lpToken address




### `getAllAmountInToken(address payable _vault, address _underlyingToken, address _liquidityPool) → uint256` (public)



Returns the market value in underlying for all the lpTokens held in a specified liquidity pool


### `getLiquidityPoolTokenBalance(address payable _vault, address, address) → uint256` (public)

Get the balance of vault in lpTokens in the specified liquidity pool




### `getSomeAmountInToken(address, address, uint256 _liquidityPoolTokenAmount) → uint256` (public)

Returns the equivalent value of underlying token for given amount of lpToken




### `getRewardToken(address) → address` (public)

Note that there is no reward token for staking on Lido currently, 
but the LDO governance token could serve as reward token in the future. 
Thus, we put the address of the LDO token here. 





