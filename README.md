# 📦 Blockchain-Based Supply Chain Management System

A decentralized full-stack system to track, verify, and manage the lifecycle of products in a supply chain using **Ethereum smart contracts**, **Node.js**, **MongoDB**, **React**, and **IPFS**.

---

## 🚀 Features

- ✅ Blockchain-based product registration and updates
- 🔐 Secure transfer of ownership
- 🧾 MongoDB for off-chain data persistence
- 🖼 IPFS for decentralized file storage (e.g., product images, certificates)
- 🖥 Full-stack dashboard using React + Vite
- 🧪 Fully containerized MongoDB environment via Docker Compose

---

## ⚙️ Tech Stack

| Layer        | Technology                     |
|--------------|--------------------------------|
| Blockchain   | Solidity + Hardhat (Ethereum)  |
| Backend      | Node.js + Express              |
| Frontend     | React (Vite) + Ethers.js       |
| Database     | MongoDB (via Docker Compose)   |
| File Storage | IPFS                           |
| Dev Tools    | Hardhat, Docker, dotenv        |

---

## 📁 Project Structure

blockchain-based-supply-chain-management-system-/ ├── contract/        # Smart contracts in Solidity using Hardhat ├── backend/         # Node.js/Express REST API for product tracking ├── frontend/        # React (Vite) based UI to interact with contracts ├── mongo/           # MongoDB setup with Docker Compose ├── scripts/         # Project setup and automation scripts └── README.md        # Project documentation (this file)

---

## 📦 Installation

### 📌 Prerequisites

- [Node.js](https://nodejs.org/) (v18+)
- [Docker](https://www.docker.com/)
- [IPFS CLI](https://docs.ipfs.tech/) (optional)
- [Git](https://git-scm.com/)

---

## 🧰 Setup Instructions

1. **Clone the repository:**

```bash
git clone https://github.com/allyelvis/blockchain-based-supply-chain-management-system-.git
cd blockchain-based-supply-chain-management-system-

2. Run automated setup script:



chmod +x scripts/setup.sh
./scripts/setup.sh


---

🔧 Manual Setup (Optional)

1. Start Hardhat local blockchain

cd contract
npx hardhat node

2. Compile & Deploy Contract

npx hardhat compile
npx hardhat run scripts/deploy.js --network localhost

Update the deployed contract address in frontend/src/supplyChain.js.


---

3. Backend API

cd backend
npm install
node index.js

API available at http://localhost:5000


---

4. MongoDB (via Docker)

cd mongo
docker-compose up -d


---

5. Frontend (React)

cd frontend
npm install
npm run dev

Frontend runs at http://localhost:5173


---

🧠 Smart Contract Sample

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


---

🛰 API Endpoints (Express)


---

🖼 IPFS Integration (optional)

To initialize IPFS:

ipfs init
ipfs daemon

You can now add assets to IPFS and store returned hashes in the blockchain or MongoDB.


---

✅ License

MIT License © 2025 Ally Elvis


---

👨‍💻 Author

Ally Elvis
📧 allyelvis6569@gmail.com
🌐 github.com/allyelvis


---

---

### ✅ Next Steps

Would you like me to:

1. **Commit this `README.md` to your GitHub repo?**
2. Add deployment support (e.g. Vercel for frontend, Railway for backend)?
3. Generate UML or architecture diagrams?

