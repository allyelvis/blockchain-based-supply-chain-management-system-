#!/bin/bash
set -e
echo "🚀 Starting Blockchain Supply Chain Setup..."

npm install -g hardhat create-vite ipfs-cli

mkdir -p {contract,backend,frontend,mongo}

# Hardhat Setup
cd contract
npm init -y
npm install --save-dev hardhat
npx hardhat init -y

cat > contracts/SupplyChain.sol <<EOL
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    struct Product {
        string name;
        string origin;
        string status;
        address currentHolder;
    }

    mapping(string => Product) public products;

    function registerProduct(string memory id, string memory name, string memory origin) public {
        products[id] = Product(name, origin, "Created", msg.sender);
    }

    function updateStatus(string memory id, string memory status) public {
        require(products[id].currentHolder == msg.sender, "Not authorized");
        products[id].status = status;
    }

    function transferHolder(string memory id, address newHolder) public {
        require(products[id].currentHolder == msg.sender, "Not authorized");
        products[id].currentHolder = newHolder;
    }
}
EOL

cd ../backend
npm init -y
npm install express cors dotenv mongoose

cat > index.js <<EOL
const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();
const app = express();

app.use(express.json());
app.use(require('cors')());

mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/supply-chain', {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => console.log("MongoDB Connected"));

app.get('/', (req, res) => res.send('API is running'));

app.listen(5000, () => console.log('Backend listening on http://localhost:5000'));
EOL

echo "MONGO_URI=mongodb://localhost:27017/supply-chain" > .env

cd ../frontend
npm create vite@latest . --template react
npm install
npm install ethers

echo "export const CONTRACT_ADDRESS = '0xYourContractAddress';" > src/supplyChain.js

cd ../mongo
cat > docker-compose.yml <<EOL
version: '3.8'
services:
  mongodb:
    image: mongo
    container_name: supply_chain_mongo
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

volumes:
  mongo_data:
EOL

ipfs init || true

cd ..
echo "✅ Setup Complete"
