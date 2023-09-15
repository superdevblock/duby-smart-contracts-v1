/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const PRIVATE_KEY_SET = JSON.parse(process.env.PRIVATE_KEY_SET);

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    dynoMainNet: {
      url: "https://rpc.dynochain.io/",
      accounts: [PRIVATE_KEY_SET.DNDMainNet],
    },
    dynoTestNet: {
      url: "https://rpctest.dynochain.io",
      accounts: [PRIVATE_KEY_SET.DNDTestNet],
    },
    bscMainNet: {
      url: "https://bsc-dataseed.binance.org",
      accounts: [PRIVATE_KEY_SET.BSCMainNet],
    },
    bscTestNet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      accounts: [PRIVATE_KEY_SET.BSCTestNet],
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.0",
      },
      {
        version: "0.8.1",
      },
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 40000,
  },
};
