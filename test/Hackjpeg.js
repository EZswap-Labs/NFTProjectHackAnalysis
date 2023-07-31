const { ethers } = require("hardhat");


describe("go to hack jpeg", function () {
  it("go", async function () {
    [signer] = await ethers.getSigners();
    const c = await ethers.getContractFactory("jpeghack")
    let hack = await c.deploy()
    console.log(await ethers.provider.getBalance(signer.address))
    await hack.hack()
    console.log(await ethers.provider.getBalance(signer.address))
  });
});
