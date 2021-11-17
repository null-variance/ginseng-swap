require("@nomiclabs/hardhat-waffle");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const mnemonic = process.env.MNEMONIC_PHRASE;

const mainnetKey = process.env.MAINNET_KEY;
const rinkebyKey = process.env.RINKEBY_KEY;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.7.5",
  defaultNewtork: "mainnet",
  networks: {
    hardhat: {
    },
    mainnet: {
      url: "https://mainnet.infura.io/v3/{}",
      accounts: [mnemonic],
    }
  },
  path: {
    sources: "./contracts",
    tests: ".test",
    cache: "./cache",
    artifacts: "./artifacts",
  }
};
