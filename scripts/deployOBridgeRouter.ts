import { ethers } from "hardhat";

async function main() {
  const WNativeToken = "0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd";

  const OBridgeRouter = await ethers.getContractFactory("OBridgeRouter");
  const obridgerouter = await OBridgeRouter.deploy(WNativeToken);

  await obridgerouter.deployed();

  console.log(`Deployed to ${obridgerouter.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
