require('dotenv').config();
console.log("Private Key:", process.env.PRIVATE_KEY);

require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: "0.8.24",
  networks: {
    amoy: {
      url: "https://polygon-amoy.infura.io/v3/c383c0c0c1fc4e0582a0a5931bffbb13",
      accounts: [process.env.PRIVATE_KEY].filter(Boolean),
      gas: 10000000
    }
  }
};
