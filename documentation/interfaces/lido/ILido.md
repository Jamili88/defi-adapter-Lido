## `ILido`






### `getPooledEthByShares(uint256 _sharesAmount) → uint256` (external)





### `getSharesByPooledEth(uint256 _pooledEthAmount) → uint256` (external)





### `sharesOf(address _account) → uint256` (external)





### `getTotalShares() → uint256` (external)





### `stop()` (external)

Stop pool routine operations



### `resume()` (external)

Resume pool routine operations



### `setFee(uint16 _feeBasisPoints)` (external)

Set fee rate to `_feeBasisPoints` basis points. The fees are accrued when oracles report staking results




### `setFeeDistribution(uint16 _treasuryFeeBasisPoints, uint16 _insuranceFeeBasisPoints, uint16 _operatorsFeeBasisPoints)` (external)

Set fee distribution: `_treasuryFeeBasisPoints` basis points go to the treasury, `_insuranceFeeBasisPoints` basis points go to the insurance fund, `_operatorsFeeBasisPoints` basis points go to node operators. The sum has to be 10 000.



### `getFee() → uint16 feeBasisPoints` (external)

Returns staking rewards fee rate



### `getFeeDistribution() → uint16 treasuryFeeBasisPoints, uint16 insuranceFeeBasisPoints, uint16 operatorsFeeBasisPoints` (external)

Returns fee distribution proportion



### `setWithdrawalCredentials(bytes32 _withdrawalCredentials)` (external)

Set credentials to withdraw ETH on ETH 2.0 side after the phase 2 is launched to `_withdrawalCredentials`


Note that setWithdrawalCredentials discards all unused signing keys as the signatures are invalidated.


### `getWithdrawalCredentials() → bytes` (external)

Returns current credentials to withdraw ETH on ETH 2.0 side after the phase 2 is launched



### `pushBeacon(uint256 _epoch, uint256 _eth2balance)` (external)

Ether on the ETH 2.0 side reported by the oracle




### `submit(address _referral) → uint256 StETH` (external)

Adds eth to the pool




### `withdraw(uint256 _amount, bytes32 _pubkeyHash)` (external)

Issues withdrawal request. Large withdrawals will be processed only after the phase 2 launch.




### `getTotalPooledEther() → uint256` (external)

Gets the amount of Ether controlled by the system



### `getBufferedEther() → uint256` (external)

Gets the amount of Ether temporary buffered on this contract balance



### `getBeaconStat() → uint256 depositedValidators, uint256 beaconValidators, uint256 beaconBalance` (external)

Returns the key values related to Beacon-side





### `Stopped()`





### `Resumed()`





### `FeeSet(uint16 feeBasisPoints)`





### `FeeDistributionSet(uint16 treasuryFeeBasisPoints, uint16 insuranceFeeBasisPoints, uint16 operatorsFeeBasisPoints)`





### `WithdrawalCredentialsSet(bytes32 withdrawalCredentials)`





### `Submitted(address sender, uint256 amount, address referral)`





### `Unbuffered(uint256 amount)`





### `Withdrawal(address sender, uint256 tokenAmount, uint256 sentFromBuffer, bytes32 pubkeyHash, uint256 etherAmount)`





