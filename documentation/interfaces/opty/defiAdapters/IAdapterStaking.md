## `IAdapterStaking`

Interface of the DeFi protocol adapter for staking functionality


Abstraction layer to different DeFi protocols like Harvest.finance, DForce etc.
It is used as a layer for adding any new staking functions being used in DeFi adapters.
Conventions used:
 - lpToken: liquidity pool token


### `getStakeSomeCodes(address _liquidityPool, uint256 _stakeAmount) → bytes[] _codes` (external)

Get batch of function calls for staking specified amount of lpToken held in a vault




### `getStakeAllCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool) → bytes[] _codes` (external)

Get batch of function calls for staking full balance of lpTokens held in a vault




### `getUnstakeSomeCodes(address _liquidityPool, uint256 _unstakeAmount) → bytes[]` (external)

Get batch of function calls for unstaking specified amount of lpTokens held in a vault




### `getUnstakeAllCodes(address payable _vault, address _liquidityPool) → bytes[] _codes` (external)

Get the batch of function calls for unstaking whole balance of lpTokens held in a vault




### `getAllAmountInTokenStake(address payable _vault, address _underlyingToken, address _liquidityPool) → uint256` (external)

Returns the balance in underlying for staked lpToken balance of vault




### `getLiquidityPoolTokenBalanceStake(address payable _vault, address _liquidityPool) → uint256` (external)

Returns amount of lpTokens staked by the vault




### `calculateRedeemableLPTokenAmountStake(address payable _vault, address _underlyingToken, address _liquidityPool, uint256 _redeemAmount) → uint256 _amount` (external)

Returns the equivalent amount in underlying token if the given amount of lpToken is unstaked and redeemed




### `isRedeemableAmountSufficientStake(address payable _vault, address _underlyingToken, address _liquidityPool, uint256 _redeemAmount) → bool` (external)

Checks whether the given amount of underlying token can be received for full balance of staked lpToken




### `getUnstakeAndWithdrawSomeCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool, uint256 _redeemAmount) → bytes[] _codes` (external)

Get the batch of function calls for unstake and redeem specified amount of shares




### `getUnstakeAndWithdrawAllCodes(address payable _vault, address[] _underlyingTokens, address _liquidityPool) → bytes[] _codes` (external)

Get the batch of function calls for unstake and redeem whole balance of shares held in a vault





