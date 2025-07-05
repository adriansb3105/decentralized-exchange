const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const TokenA = await ethers.getContractFactory("TokenA");
  const tokenA = await TokenA.deploy(ethers.parseEther("1000000"));
  await tokenA.waitForDeployment();
  console.log("TokenA deployed at:", tokenA.target);

  const TokenB = await ethers.getContractFactory("TokenB");
  const tokenB = await TokenB.deploy(ethers.parseEther("1000000"));
  await tokenB.waitForDeployment();
  console.log("TokenB deployed at:", tokenB.target);

  const SimpleDEX = await ethers.getContractFactory("SimpleDEX");
  const dex = await SimpleDEX.deploy(tokenA.target, tokenB.target);
  await dex.waitForDeployment();
  console.log("SimpleDEX deployed at:", dex.target);
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
