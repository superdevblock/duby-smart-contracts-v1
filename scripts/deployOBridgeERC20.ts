import { ethers } from "hardhat";

async function main() {
  const tokenName = "OBbridge Test Token 2";
  const tokenSymbol = "OB_TT2";
  const decimal = 9;
  const orgToken = "0x71aAe0395d38B7626172c14876e03fBA024a9f52";

  const chainRouter = "0x66b2FAFc8c5FC3A85d845804d156e9DEd21f321D";

  const OBridgeERC20 = await ethers.getContractFactory("OBridgeERC20");
  const bridgeerc20 = await OBridgeERC20.deploy(
    tokenName,
    tokenSymbol,
    decimal,
    orgToken
  );

  await bridgeerc20.deployed();
  await bridgeerc20.init(chainRouter);

  console.log(`Deployed to ${bridgeerc20.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
