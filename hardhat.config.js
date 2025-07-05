require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    scroll: {
      url: process.env.SCROLL_RPC,
      accounts: [`0x${process.env.PRIVATE_KEY}`],
    },
    // local para hardhat node
    localhost: {
      url: "http://127.0.0.1:8545",
    }
  }
};
