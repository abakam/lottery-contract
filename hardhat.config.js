require('@nomiclabs/hardhat-ethers');
const { apiKey, privateKey} = require('./secrets.json');

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.5",
  networks: {
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${apiKey}`,
      accounts: [privateKey], 
      gas: 100000000000000
    },
  },
};
