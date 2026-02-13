# 🚀 Generative NFT Collection Launchpad with Merkle Tree Allowlist

A full-featured NFT launchpad built using Solidity, Hardhat, Next.js, and Docker.

This project implements a production-ready ERC-721 NFT contract with:

- ✅ Allowlist minting using Merkle Trees
- ✅ Public minting
- ✅ Reveal mechanism
- ✅ ERC-2981 royalties
- ✅ Gas-optimized design
- ✅ Secure withdrawal
- ✅ Docker containerization
- ✅ Next.js minting DApp
- ✅ Hardhat unit testing

---

# 📦 Tech Stack

### Smart Contract

- Solidity ^0.8.20
- OpenZeppelin Contracts
- Hardhat
- MerkleTree.js

### Frontend

- Next.js 14
- Ethers.js v6
- React 18

### DevOps

- Docker
- Docker Compose

---

# 📁 Project Structure

generative-nft-launchpad/
│
├── contracts/
│ └── MyNFT.sol
│
├── scripts/
│ ├── deploy.js
│ ├── generate-merkle.js
│
├── test/
│ └── MyNFT.test.js
│
├── frontend/
│ └── src/app/page.tsx
│
├── docker-compose.yml
├── Dockerfile
├── hardhat.config.js
├── package.json
├── .env.example
└── README.md

---

# 🔥 Smart Contract Features

### ERC721

Implements NFT ownership standard.

### ERC2981

Royalty support for secondary sales.

### Sale Phases

enum SaleState { Paused, Allowlist, Public }

### Allowlist Minting

Uses Merkle Tree root stored on-chain.

### Public Mint

### Reveal Mechanism

Two URIs:

- Unrevealed Base URI
- Revealed Final URI

### Gas Optimized

- Custom errors
- Minimal storage reads
- No ERC721Enumerable

### Security

- Ownable
- ReentrancyGuard
- Checks-Effects-Interactions

---

# 🛠 Installation

## 1️⃣ Install Root Dependencies

npm install

## 2️⃣ Install Frontend Dependencies

cd frontend  
npm install  
cd ..

---

# 🐳 Run with Docker (Recommended)

docker compose up --build

Access:

- Hardhat Node → http://localhost:8545
- Frontend → http://localhost:3000

---

# 🧪 Run Tests

npx hardhat test

---

# 🚀 Deploy Locally

Start Hardhat node:

npx hardhat node

In new terminal:

npx hardhat run scripts/deploy.js --network localhost

Update:
NEXT_PUBLIC_CONTRACT_ADDRESS

Restart frontend.

---

# 🌍 Deploy to Sepolia

1️⃣ Create .env

SEPOLIA_RPC_URL=YOUR_INFURA_URL  
PRIVATE_KEY=YOUR_WALLET_PRIVATE_KEY

2️⃣ Deploy:

npx hardhat run scripts/deploy.js --network sepolia

---

# 🌳 Generate Merkle Root

Create allowlist.json

Example:

[
"0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
"0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"
]

Run:

node scripts/generate-merkle.js

Copy printed root into contract using:

setMerkleRoot(bytes32 root)

---

# 🎨 NFT Metadata Format

{
"name": "My NFT #1",
"description": "A unique generative NFT.",
"image": "ipfs://CID/1.png",
"attributes": [
{ "trait_type": "Background", "value": "Blue" },
{ "trait_type": "Eyes", "value": "Laser" }
]
}

---

# 🔐 Security Considerations

- Uses ReentrancyGuard
- OnlyOwner modifiers
- MerkleProof verification
- Per-wallet mint limits
- Supply caps enforced

---

# ⚡ Gas Optimization Decisions

- Avoided ERC721Enumerable
- Used custom errors
- Minimized storage writes
- Loop minting with internal counter

---

# 📊 Frontend Features

- Wallet connection (MetaMask)
- Sale state display
- Mint quantity selector
- Transaction confirmation
- Real-time supply updates

---

# 🧠 Why Merkle Trees?

Storing 1000 addresses on-chain is extremely expensive.

Instead:

- Store only 32-byte Merkle Root
- Users provide proof
- Contract verifies membership
- Massive gas savings

---

# 🏆 Industry Use Cases

- NFT Gaming Collections
- E-commerce Drops
- DAO Membership NFTs
- Web3 Ticketing
- Creator Economy Platforms

---

# 👨‍💻 Author

Built as a production-level Web3 NFT Launchpad simulation.

---

# 📜 License

MIT
