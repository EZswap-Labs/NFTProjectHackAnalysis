require("@nomicfoundation/hardhat-toolbox");


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",

  networks: {
    hardhat: {
      forking: {
        url: 'https://eth.llamarpc.com',
        blockNumber: 17806055
      }
    }
  }
};
