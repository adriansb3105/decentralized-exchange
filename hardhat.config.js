require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.28",
  networks: {
    scroll: {
      url: process.env.SCROLL_RPC,
      accounts: [`0x${process.env.PRIVATE_KEY}`],
      chainId: 534351
    },
  },
  etherscan: {
    apiKey: {
      scroll: "blockscout"  // cualquier string para evitar el error
    },
    customChains: [
      {
        network: "scroll",
        chainId: 534351,
        urls: {
          apiURL: "https://sepolia-blockscout.scroll.io/api",
          browserURL: "https://sepolia.scrollscan.com"
        }
      }
    ]
  }
};
