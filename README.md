# TangibleX 🌐

**RealFi Infrastructure Platform on Mantle Network**

TangibleX is a comprehensive RealFi (Real-World Finance) platform built on Mantle Network that enables compliant tokenization of real-world cashflow assets. The platform leverages AI-powered risk analysis, automated oracles, and yield distribution to create a seamless bridge between traditional finance and DeFi.

## 🏗️ Architecture

TangibleX consists of three main components:

### 1. Smart Contracts (Solidity + Foundry)
- **KYCManager**: Role-based KYC verification system
- **AssetRegistry**: On-chain registry for real-world assets with IPFS metadata
- **RWAERC20**: Compliant ERC-20 tokens with KYC-gated transfers
- **YieldVault**: Automated yield distribution with oracle integration
- **OracleUpdater**: Bridge for off-chain data to on-chain state

### 2. Backend (Node.js + Express)
- **AI Agent**: OpenAI-powered asset analysis, risk scoring, and yield prediction
- **Oracle Worker**: Automated on-chain updates using Mantle SDK
- **REST API**: Endpoints for assets, analysis, KYC, and yield data
- **IPFS Integration**: Document storage via Pinata

### 3. Frontend (React + Vite + Wagmi)
- **Dashboard**: Platform overview with key metrics
- **Marketplace**: Browse and invest in tokenized assets
- **Portfolio**: Track holdings and yield earnings
- **KYC Flow**: Document upload and verification
- **Admin Panel**: Asset and user management

## 🚀 Quick Start

### Prerequisites
- Node.js v18+
- Foundry
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/TangibleX.git
cd TangibleX

# Install backend dependencies
cd backend
npm install

# Install frontend dependencies
cd ../frontend
npm install

# Install contract dependencies (Foundry)
cd ../contracts
forge install
```

### Environment Setup

Create `.env` files in the root directory:

```bash
# Blockchain
PRIVATE_KEY=your_private_key_here
MANTLE_RPC_URL=https://rpc.sepolia.mantle.xyz
MANTLE_EXPLORER_API_KEY=your_explorer_api_key

# Backend
PORT=3000
NODE_ENV=development
OPENAI_API_KEY=your_openai_api_key

# IPFS
PINATA_API_KEY=your_pinata_api_key
PINATA_SECRET_KEY=your_pinata_secret_key

# Frontend
VITE_MANTLE_CHAIN_ID=5003
VITE_API_BASE_URL=http://localhost:3000
VITE_WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id

# Contract Addresses (fill after deployment)
KYC_MANAGER_ADDRESS=
ASSET_REGISTRY_ADDRESS=
ORACLE_UPDATER_ADDRESS=
YIELD_VAULT_ADDRESS=
```

## 📝 Development

### Running the Contracts

```bash
cd contracts

# Compile contracts
forge build

# Run tests
forge test

# Deploy to Mantle Testnet
forge script script/Deploy.s.sol:DeployScript --rpc-url $MANTLE_RPC_URL --broadcast --verify

# After deployment, copy the contract addresses to your .env file
```

### Running the Backend

```bash
cd backend

# Start the API server
npm run dev

# Start the oracle worker (in a separate terminal)
npm run oracle
```

### Running the Frontend

```bash
cd frontend

# Start the development server
npm run dev

# Build for production
npm run build
```

## 🔧 Smart Contract Deployment

### Step 1: Get Testnet MNT

Visit the [Mantle Sepolia Faucet](https://faucet.sepolia.mantle.xyz/) to get testnet MNT tokens.

### Step 2: Deploy Contracts

```bash
cd contracts
forge script script/Deploy.s.sol:DeployScript --rpc-url https://rpc.sepolia.mantle.xyz --broadcast --verify
```

### Step 3: Update Environment Variables

Copy the deployed contract addresses from the console output and add them to your `.env` file.

### Step 4: Verify Contracts (if not auto-verified)

```bash
forge verify-contract <CONTRACT_ADDRESS> <CONTRACT_NAME> --chain mantle-sepolia --etherscan-api-key $MANTLE_EXPLORER_API_KEY
```

## 📊 Key Features

### Compliant Asset Tokenization
- KYC-gated transfers ensure regulatory compliance
- Role-based access control (Admin, Issuer, Auditor)
- IPFS-backed asset documentation

### AI-Powered Analytics
- Automated risk scoring using OpenAI GPT-4
- Yield prediction based on market conditions
- Document analysis for due diligence

### Automated Oracle System
- Scheduled price updates (every 5 minutes)
- Risk score recalculation
- On-chain data feeds for external integrations

### User-Friendly Interface
- Wallet connection via RainbowKit
- Real-time asset data from Mantle Network
- Responsive design with TailwindCSS

## 🏛️ Smart Contract Architecture

```
┌─────────────────┐
│   KYCManager    │ ← Manages user verification
└────────┬────────┘
         │
         ↓
┌─────────────────┐     ┌──────────────────┐
│  AssetRegistry  │ ←──→│   RWAERC20       │
└────────┬────────┘     └──────────────────┘
         │
         ↓
┌─────────────────┐     ┌──────────────────┐
│  YieldVault     │ ←──→│ OracleUpdater    │
└─────────────────┘     └──────────────────┘
```

## 🌐 API Endpoints

### Assets
- `GET /api/assets` - List all active assets
- `GET /api/assets/:assetId` - Get asset details

### Analysis
- `POST /api/analysis/document` - Analyze asset document
- `POST /api/analysis/risk-score` - Calculate risk score
- `POST /api/analysis/yield-prediction` - Predict yield

### KYC
- `POST /api/kyc/submit` - Submit KYC document
- `GET /api/kyc/status/:address` - Check KYC status

### Yield
- `GET /api/yield/claimable/:assetId/:address` - Get claimable yield
- `GET /api/yield/pool/:assetId` - Get yield pool info

## 🧪 Testing

```bash
# Run contract tests
cd contracts
forge test -vvv

# Run backend tests (if implemented)
cd backend
npm test

# Run frontend tests (if implemented)
cd frontend
npm test
```

## 📦 Deployment

### Backend Deployment (Render/Railway)

1. Create a new web service
2. Connect your GitHub repository
3. Set environment variables
4. Deploy

### Frontend Deployment (Vercel)

1. Import project from GitHub
2. Set build command: `npm run build`
3. Set output directory: `dist`
4. Add environment variables
5. Deploy

## 🔐 Security Considerations

- All smart contracts use OpenZeppelin's audited libraries
- KYC verification required for token transfers
- Role-based access control on critical functions
- ReentrancyGuard on vault operations
- Private keys managed via environment variables

## 📜 Contract Addresses (Mantle Sepolia Testnet)

Update after deployment:

```
KYCManager: TBD
AssetRegistry: TBD
OracleUpdater: TBD
YieldVault: TBD
```

## 🎯 Roadmap

- [x] Core smart contracts
- [x] Backend API with AI agents
- [x] Oracle automation
- [x] Frontend UI/UX
- [ ] Mantle mainnet deployment
- [ ] Additional asset types (NFTs, derivatives)
- [ ] Cross-chain bridging
- [ ] Mobile app

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for Mantle Network Hackathon
- Powered by OpenZeppelin contracts
- UI components inspired by shadcn/ui
- Oracle infrastructure using Mantle SDK

## 📞 Contact

- Website: [tangiblex.io](https://tangiblex.io) (TBD)
- Twitter: [@TangibleX](https://twitter.com/TangibleX) (TBD)
- Discord: [Join our community](https://discord.gg/tangiblex) (TBD)

---

**Built with ❤️ on Mantle Network**
