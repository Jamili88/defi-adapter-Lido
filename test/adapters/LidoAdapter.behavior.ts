import hre from "hardhat";
import chai, { expect } from "chai";
import { solidity } from "ethereum-waffle";
import { PoolItem } from "../types";
import { getOverrideOptions } from "../utils";
import { ILido } from "../../typechain/ILido";

chai.use(solidity);

export function shouldBehaveLikeLidoAdapter(token: string, pool: PoolItem): void {
  it(`should deposit ${token} for stETH, and be able to sell stETH in exchange for ${token}`, async function () {
    // Instance of Lido Contract
    const lidoContract: ILido = await hre.ethers.getContractAt("ILido", pool.pool) as ILido;

    // 1. deposit all underlying tokens
    await this.testDeFiAdapter.testGetDepositAllCodes(
      pool.tokens[0],
      pool.pool,
      this.lidoAdapter.address,
      getOverrideOptions(),
    );
    // 1.1 assert whether lptoken balance is as expected or not after deposit
    const actualLPTokenBalanceAfterDeposit = await this.lidoAdapter.getLiquidityPoolTokenBalance(
      this.testDeFiAdapter.address,
      this.testDeFiAdapter.address, // placeholder of type address
      pool.pool,
    );
    const expectedLPTokenBalanceAfterDeposit = await lidoContract.sharesOf(this.testDeFiAdapter.address);
    expect(actualLPTokenBalanceAfterDeposit).to.be.eq(expectedLPTokenBalanceAfterDeposit);

    // 1.2 assert whether underlying token balance is as expected or not after deposit
    const actualUnderlyingTokenBalanceAfterDeposit = await hre.ethers.provider.getBalance(this.testDeFiAdapter.address);
    // We deposit all our ETH
    expect(actualUnderlyingTokenBalanceAfterDeposit).to.be.eq(0);

    // 1.3 assert whether the amount in token is as expected or not after depositing
    const actualAmountInTokenAfterDeposit = await this.lidoAdapter.getAllAmountInToken(
      this.testDeFiAdapter.address,
      pool.tokens[0],
      pool.pool,
    );

    const expectedAmountInTokenAfterDeposit = await lidoContract.balanceOf(this.testDeFiAdapter.address);
    expect(actualAmountInTokenAfterDeposit).to.be.eq(expectedAmountInTokenAfterDeposit);

    // Let's see how much pooled ETH we should be able to withdraw
    const expectedUnderlyingTokenBalanceAfterWithdraw = await lidoContract.balanceOf(this.testDeFiAdapter.address);

    // 2. Withdraw all lpToken balance
    // This will sell our stETH for ETH on curve
    await this.testDeFiAdapter.testGetWithdrawAllCodes(
      pool.tokens[0],
      pool.pool,
      this.lidoAdapter.address,
      getOverrideOptions(),
    );


    // 2.1 assert whether lpToken balance is as expected or not
    const actualLPTokenBalanceAfterWithdraw = await this.lidoAdapter.getLiquidityPoolTokenBalance(
      this.testDeFiAdapter.address,
      this.testDeFiAdapter.address, // placeholder of type address
      pool.pool,
    );
    const expectedLPTokenBalanceAfterWithdraw = await lidoContract.sharesOf(this.testDeFiAdapter.address);
    // We should've sold all of our stETH into the curve pool
    expect(actualLPTokenBalanceAfterWithdraw).to.be.eq(expectedLPTokenBalanceAfterWithdraw);

    // 2.2 assert whether underlying token balance is as expected or not after withdraw
    const actualUnderlyingTokenBalanceAfterWithdraw = await hre.ethers.provider.getBalance(this.testDeFiAdapter.address);
    // We have max slippage of 1%, so let's make sure that we got enough ETH back from Curve
    expect(actualUnderlyingTokenBalanceAfterWithdraw).to.be.gt(expectedUnderlyingTokenBalanceAfterWithdraw.mul(99).div(100));
  });

  it(`should return the LDO token address (possible future reward token) and indicate staking is not possible.`, async function () {
        // The address argument does not actually matter
        const ldoGovernanceToken = await this.lidoAdapter.getRewardToken("0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE");
        expect(ldoGovernanceToken).to.be.eq("0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32");

        // Staking should not be possible
        const isStakingAllowed = await this.lidoAdapter.canStake("0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE");
        expect(isStakingAllowed).to.be.eq(false);
  });
}
