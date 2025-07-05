const { expect } = require("chai");

describe("SimpleDEX", function () {
  it("should allow adding liquidity and swapping", async function () {
    const [owner, user] = await ethers.getSigners();

    const TokenA = await ethers.getContractFactory("TokenA");
    const TokenB = await ethers.getContractFactory("TokenB");
    const SimpleDEX = await ethers.getContractFactory("SimpleDEX");

    const tokenA = await TokenA.deploy(ethers.parseEther("1000000"));
    const tokenB = await TokenB.deploy(ethers.parseEther("1000000"));
    await tokenA.waitForDeployment();
    await tokenB.waitForDeployment();

    const dex = await SimpleDEX.deploy(tokenA.target, tokenB.target);
    await dex.waitForDeployment();

    await tokenA.approve(dex.target, ethers.parseEther("1000"));
    await tokenB.approve(dex.target, ethers.parseEther("1000"));
    await dex.addLiquidity(ethers.parseEther("1000"), ethers.parseEther("1000"));

    await tokenA.transfer(user.address, ethers.parseEther("100"));
    await tokenA.connect(user).approve(dex.target, ethers.parseEther("50"));
    await dex.connect(user).swapAforB(ethers.parseEther("50"));

    expect(await tokenB.balanceOf(user.address)).to.be.gt(0);
  });
});
