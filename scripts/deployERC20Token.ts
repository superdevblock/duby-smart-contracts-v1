import { ethers } from "hardhat";

async function main() {
  const ERC20Token = await ethers.getContractFactory("ERC20Token");
  const erc20token = await ERC20Token.deploy("Dyno Binance Coin", "BNB", 18);

  await erc20token.deployed();

  console.log(`Deployed to ${erc20token.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
