## `IAdapter`

Interface with minimal functions to be inhertied in all DeFi adapters


Abstraction layer to different DeFi protocols like AaveV1, Compound etc.
It is used as a layer for adding any new function which will be used in all DeFi adapters
Conventions used:
 - lpToken: liquidity pool token


### `getPoolValue(address _liquidityPool, address _underlyingToken) → uint256` (external)

Returns pool value in underlying token (for all adapters except Curve for which the poolValue is
in US dollar) for the given liquidity pool and underlyingToken


poolValue can be in US dollar for protocols like Curve if explicitly specified, underlyingToken otherwise
for protocols like Compound etc.


### `getDepositSomeCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool, uint256[] _amounts) → bytes[] _codes` (external)



Get batch of function calls for depositing specified amount of underlying token in given liquidity pool


### `getDepositAllCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool) → bytes[] _codes` (external)



Get batch of function calls for depositing vault's full balance in underlying tokens in given liquidity pool


### `getWithdrawSomeCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool, uint256 _amount) → bytes[] _codes` (external)

Get batch of function calls for redeeming specified amount of lpTokens held in the vault


Redeem specified `amount` of `liquidityPoolToken` and send the `underlyingToken` to the caller`


### `getWithdrawAllCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool) → bytes[] _codes` (external)

Get batch of function calls for redeeming full balance of lpTokens held in the vault


Redeem full `amount` of `liquidityPoolToken` and send the `underlyingToken` to the caller`


### `getLiquidityPoolToken(address _underlyingToken, address _liquidityPool) → address` (external)

Get the lpToken address




### `getUnderlyingTokens(address _liquidityPool, address _liquidityPoolToken) → address[] _underlyingTokens` (external)

Get the underlying token addresses given the liquidity pool and/or lpToken


there are some defi pools which requires liqudiity pool and lpToken's address to return underlying token


### `getAllAmountInToken(address payable _vault, address _underlyingToken, address _liquidityPool) → uint256` (external)



Returns the market value in underlying for all the lpTokens held in a specified liquidity pool


### `getLiquidityPoolTokenBalance(address payable _vault, address _underlyingToken, address _liquidityPool) → uint256` (external)

Get the balance of vault in lpTokens in the specified liquidity pool




### `getSomeAmountInToken(address _underlyingToken, address _liquidityPool, uint256 _liquidityPoolTokenAmount) → uint256` (external)

Returns the equivalent value of underlying token for given amount of lpToken




### `calculateAmountInLPToken(address _underlyingToken, address _liquidityPool, uint256 _underlyingTokenAmount) → uint256` (external)



Returns the equivalent value of lpToken for given amount of underlying token


### `calculateRedeemableLPTokenAmount(address payable _vault, address _underlyingToken, address _liquidityPool, uint256 _redeemAmount) → uint256 _amount` (external)



Returns the market value in underlying token of the shares in the specified liquidity pool


### `isRedeemableAmountSufficient(address payable _vault, address _underlyingToken, address _liquidityPool, uint256 _redeemAmount) → bool` (external)

Checks whether the vault has enough lpToken (+ rewards) to redeem for the specified amount of shares




### `getRewardToken(address _liquidityPool) → address` (external)

Returns reward token address for the liquidity pool provided




### `canStake(address _liquidityPool) → bool` (external)

Returns whether the protocol can stake lpToken





