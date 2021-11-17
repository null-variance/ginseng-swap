const hre = require("hardhat");

async function main() {

  // We get the contract to deploy
  const GinsengSwap = await hre.ethers.getContractFactory("Ginseng");
  const ginsengswap = await GinsengSwap.deploy();

  await ginsengswap.deployed();

  console.log("GinsengSwap deployed to:", ginsengswap.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
