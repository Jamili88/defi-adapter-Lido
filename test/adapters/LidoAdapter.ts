import hre from "hardhat";
import { Artifact } from "hardhat/types";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { LidoAdapter } from "../../typechain/LidoAdapter";
import { TestDeFiAdapter } from "../../typechain/TestDeFiAdapter";
import { LiquidityPool, Signers } from "../types";
import { shouldBehaveLikeLidoAdapter } from "./LidoAdapter.behavior";
import { default as LidoPools } from "../lido-pools.json";
import { getOverrideOptions } from "../utils";

const { deployContract } = hre.waffle;

describe("Unit tests", function () {
  before(async function () {
    this.signers = {} as Signers;
    const signers: SignerWithAddress[] = await hre.ethers.getSigners();
    this.signers.admin = signers[0];
    this.signers.owner = signers[1];
    this.signers.deployer = signers[2];
    this.signers.alice = signers[3];

    // deploy Lido Adapter
    const LidoAdapter: Artifact = await hre.artifacts.readArtifact("LidoAdapter");
    this.lidoAdapter = <LidoAdapter>(
      await deployContract(this.signers.deployer, LidoAdapter, [], getOverrideOptions())
    );

    // deploy TestDeFiAdapter Contract
    const testDeFiAdapterArtifact: Artifact = await hre.artifacts.readArtifact("TestDeFiAdapter");
    this.testDeFiAdapter = <TestDeFiAdapter>(
      await deployContract(this.signers.deployer, testDeFiAdapterArtifact, [], getOverrideOptions())
    );

    // Fund TestDeFiAdapter with 100 ETH
    await this.signers.admin.sendTransaction({
        to: this.testDeFiAdapter.address,
        value: hre.ethers.utils.parseEther("10"),
        ...getOverrideOptions()
    });
  });

  describe("LidoAdapter", function () {
    Object.keys(LidoPools).map((token: string) => {
      shouldBehaveLikeLidoAdapter(token, (LidoPools as LiquidityPool)[token]);
    });
  });
});
