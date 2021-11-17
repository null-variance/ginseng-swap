const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Ginseng", function () {
  it("Should return the new greeting once it's changed", async function () {
    const GinsengSwap = await ethers.getContractFactory("Ginseng");
    const ginsengswap = await GinsengSwap.deploy("Hello, world!");
    await ginsengswap.deployed();

    // expect(await ginsengswap.greet()).to.equal("Hello, world!");

    const setFeeSetter = await ginsengswap.setFeeSetter(/*"multisig deployment address"*/);
    const setFee = await ginsengswap.setFee(/*"fee amount"*/);

    // wait until the transaction is mined
    await setFeeSetter.wait();
    await setFee.wait();

    expect(await ginsengswap.setFeeSetter()).to.equal(/*"multisig deployment address"*/);
    expect(await ginsengswap.setFee()).to.equal(/*"fee amount"*/);
  });
});
