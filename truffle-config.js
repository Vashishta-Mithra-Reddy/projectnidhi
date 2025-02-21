require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  networks: {
    sepolia: {
      provider: () =>
        new HDWalletProvider(
          process.env.PRIVATE_KEY, 
          "https://eth-sepolia.g.alchemy.com/v2/2LojZ2mA-RdMt6JberuJV8KhEkKYFGuJ"
        ),
      network_id: 11155111, 
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
  },
  compilers: {
    solc: {
      version: "0.8.20", 
    },
  },
};
