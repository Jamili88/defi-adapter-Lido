## `IAdapterHarvestReward`

Interface of the DeFi protocol code adapter for reward tokens and swapping tokens functionality


Abstraction layer to different DeFi protocols like Compound, Cream etc.
It is used as a layer for adding any new function related to reward token feature to be used in DeFi-adapters.
It is also used as a middleware for adding functionality of swapping/harvesting of tokens used in DeFi-adapters.


### `getUnclaimedRewardTokenAmount(address payable _vault, address _liquidityPool, address _underlyingToken) → uint256 _codes` (external)

Returns the amount of accrued reward tokens




### `getClaimRewardTokenCode(address payable _vault, address _liquidityPool) → bytes[] _codes` (external)

Get batch of function calls for claiming the reward tokens (eg: COMP etc.)




### `getHarvestSomeCodes(address payable _vault, address _underlyingToken, address _liquidityPool, uint256 _rewardTokenAmount) → bytes[] _codes` (external)



Get batch of function calls for swapping specified amount of rewards in vault to underlying tokens
via DEX like Uniswap


### `getAddLiquidityCodes(address payable _vault, address _underlyingToken) → bytes[] _codes` (external)



Get batch of function calls for adding liquidity in a DEX like Uniswap


### `getHarvestAllCodes(address payable _vault, address _underlyingToken, address _liquidityPool) → bytes[] _codes` (external)



Get batch of function calls for swapping full balance of rewards in vault to underlying tokens
via DEX like Uniswap



