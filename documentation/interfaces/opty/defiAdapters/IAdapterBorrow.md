## `IAdapterBorrow`

Interface of the DeFi protocol adapter for borrow functionality


Abstraction layer to different DeFi protocols like AaveV1, AaveV2 etc. which has borrow feature
It is used as a layer for adding any new functions in DeFi adapters if they include borrow functionality
Conventions used:
 - lpToken: liquidity pool token


### `getBorrowAllCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool, address _outputToken) → bytes[] _codes` (external)



Get batch of function calls for token amount that can be borrowed safely against the underlying token
when kept as collateral


### `getRepayAndWithdrawAllCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool, address _outputToken) → bytes[] _codes` (external)



Get batch of function calls require to repay debt, unlock collateral and redeem lpToken


### `getSomeAmountInTokenBorrow(address payable _vault, address _underlyingToken, address _liquidityPool, uint256 _liquidityPoolTokenAmount, address _borrowToken, uint256 _borrowAmount) → uint256` (external)

Get the amount in underlying token that you'll receive if borrowed token is repaid


Returns the amount in underlying token for _liquidityPoolTokenAmount collateral if
_borrowAmount in _borrowToken is repaid.


### `getAllAmountInTokenBorrow(address payable _vault, address _underlyingToken, address _liquidityPool, address _borrowToken, uint256 _borrowAmount) → uint256` (external)

Get the amount in underlying token that you'll receive if whole balance of vault borrowed token is repaid


Returns the amount in underlying token for whole collateral of _vault balance if
_borrowAmount in _borrowToken is repaid.



