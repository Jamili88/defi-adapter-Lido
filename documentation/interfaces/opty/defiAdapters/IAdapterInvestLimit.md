## `IAdapterInvestLimit`

Interface of the DeFi protocol adapter for setting invest limit for deposit


Abstraction layer to different DeFi protocols like AaveV1, Compound etc except Curve.
It is used as an interface layer for setting max invest limit and its type in number or percentage for DeFi adapters


### `setMaxDepositAmount(address _liquidityPool, address _underlyingToken, uint256 _maxDepositAmount)` (external)

Sets the absolute max deposit value in underlying for the given liquidity pool




### `setMaxDepositPoolPct(address _liquidityPool, uint256 _maxDepositPoolPct)` (external)

Sets the percentage of max deposit value for the given liquidity pool




### `setMaxDepositProtocolPct(uint256 _maxDepositProtocolPct)` (external)

Sets the percentage of max deposit protocol value




### `setMaxDepositProtocolMode(enum IAdapterInvestLimit.MaxExposure _mode)` (external)

Sets the type of investment limit
                 1. Percentage of pool value
                 2. Amount in underlying token


Types (can be number or percentage) supported for the maxDeposit value



### `LogMaxDepositProtocolMode(enum IAdapterInvestLimit.MaxExposure maxDepositProtocolMode, address caller)`

Notify when Max Deposit Protocol mode is set




### `LogMaxDepositProtocolPct(uint256 maxDepositProtocolPct, address caller)`

Notify when Max Deposit Protocol percentage is set




### `LogMaxDepositPoolPct(uint256 maxDepositPoolPct, address caller)`

Notify when Max Deposit Pool percentage is set




### `LogMaxDepositAmount(uint256 maxDepositAmount, address caller)`

Notify when Max Deposit Amount is set




