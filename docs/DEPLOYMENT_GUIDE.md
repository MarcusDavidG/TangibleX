# TangibleX Deployment Guide

This guide will walk you through deploying TangibleX to Mantle Sepolia Testnet and production hosting.

## Prerequisites

✅ **Completed:**
- [x] All dependencies installed
- [x] 34/34 contract tests passing
- [x] Repository structure set up
- [x] .env file created

⏳ **Required for Deployment:**
- [ ] Mantle Sepolia testnet MNT tokens
- [ ] OpenAI API key
- [ ] Pinata API keys
- [ ] WalletConnect Project ID
- [ ] Hosting accounts (Vercel, Render/Railway)

---

## Phase 1: Get API Keys & Testnet Tokens

### 1. Get Mantle Sepolia Testnet MNT

1. Visit [Mantle Sepolia Faucet](https://faucet.sepolia.mantle.xyz/)
2. Connect your wallet (MetaMask recommended)
3. Request testnet MNT tokens
4. Wait for confirmation

### 2. Export Your Private Key

**⚠️ SECURITY WARNING: Only use a test wallet! Never use your main wallet!**

```bash
# MetaMask:
# Account Menu → Account Details → Export Private Key
# Copy the private key (without 0x prefix)
```

### 3. Get OpenAI API Key

1. Visit [OpenAI Platform](https://platform.openai.com/api-keys)
2. Create an account or log in
3. Navigate to API Keys
4. Create new secret key
5. Copy and save the key

### 4. Get Pinata API Keys

1. Visit [Pinata](https://app.pinata.cloud/)
2. Create an account or log in
3. Go to API Keys section
4. Create new API key
5. Copy both API Key and Secret Key

### 5. Get WalletConnect Project ID

1. Visit [WalletConnect Cloud](https://cloud.walletconnect.com/)
2. Create an account or log in
3. Create a new project
4. Copy the Project ID

---

## Phase 2: Configure Environment

Update your `.env` file in the project root:

```bash
# Edit the .env file
nano .env

# Or use your preferred editor
code .env
```

Fill in these values:

```env
PRIVATE_KEY=your_actual_private_key_here
OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxx
PINATA_API_KEY=your_pinata_api_key
PINATA_SECRET_KEY=your_pinata_secret_key
VITE_WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id
```

---

## Phase 3: Deploy Smart Contracts

### 1. Test Compilation

```bash
cd contracts
forge build
```

Expected output: ✅ Compilation successful

### 2. Run All Tests

```bash
forge test -vv
```

Expected output: ✅ 34 tests passed

### 3. Deploy to Mantle Sepolia

```bash
# Deploy all contracts
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url https://rpc.sepolia.mantle.xyz \
  --broadcast \
  --verify \
  -vvvv

# Alternative without verification (verify later)
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url https://rpc.sepolia.mantle.xyz \
  --broadcast \
  -vvvv
```

### 4. Save Contract Addresses

The deployment will output addresses like:

```
KYCManager deployed at: 0x1234...
AssetRegistry deployed at: 0x5678...
OracleUpdater deployed at: 0x9abc...
YieldVault deployed at: 0xdef0...
```

**Copy these addresses to your .env file:**

```env
KYC_MANAGER_ADDRESS=0x1234...
ASSET_REGISTRY_ADDRESS=0x5678...
ORACLE_UPDATER_ADDRESS=0x9abc...
YIELD_VAULT_ADDRESS=0xdef0...
```

### 5. Verify Contracts (if not auto-verified)

```bash
# Verify each contract
forge verify-contract <CONTRACT_ADDRESS> src/KYCManager.sol:KYCManager \
  --chain mantle-sepolia \
  --etherscan-api-key $MANTLE_EXPLORER_API_KEY

# Repeat for each contract:
# - AssetRegistry
# - OracleUpdater
# - YieldVault
# - RWAERC20
```

### 6. View on Explorer

Visit your contracts on [Mantle Sepolia Explorer](https://sepolia.mantlescan.xyz/)

---

## Phase 4: Export ABIs to Frontend

```bash
# From project root
cd scripts
chmod +x export-abis.sh
./export-abis.sh

# Or manually:
cd contracts
forge script script/ExportABI.s.sol
```

This will create ABI files in `frontend/src/abis/`

---

## Phase 5: Test Backend Locally

```bash
cd backend

# Ensure .env is in the project root
# Start the server
npm run dev
```

**Test the API:**

```bash
# Health check
curl http://localhost:3000/health

# Test assets endpoint
curl http://localhost:3000/api/assets

# Should return deployed assets (empty array if none registered yet)
```

---

## Phase 6: Test Frontend Locally

```bash
cd frontend

# Start development server
npm run dev
```

**Testing checklist:**

1. ✅ Open http://localhost:5173 in your browser
2. ✅ Connect your wallet (MetaMask with Mantle Sepolia)
3. ✅ Navigate through all pages:
   - Dashboard
   - Marketplace
   - Portfolio
   - KYC Flow
   - Admin Panel
4. ✅ Verify wallet connection works
5. ✅ Check browser console for errors

---

## Phase 7: Deploy Backend

### Option A: Deploy to Render

1. Visit [Render](https://render.com/)
2. Create a new Web Service
3. Connect your GitHub repository
4. Configure:
   - **Build Command:** `cd backend && npm install`
   - **Start Command:** `cd backend && npm start`
   - **Environment Variables:** Copy from your .env file
5. Deploy

### Option B: Deploy to Railway

1. Visit [Railway](https://railway.app/)
2. Create a new project
3. Deploy from GitHub
4. Configure environment variables
5. Deploy

### Option C: Deploy to Fly.io

```bash
# Install Fly CLI
curl -L https://fly.io/install.sh | sh

# Login
fly auth login

# Initialize
cd backend
fly launch

# Set environment variables
fly secrets set PRIVATE_KEY=your_key
fly secrets set OPENAI_API_KEY=your_key
# ... set all env vars

# Deploy
fly deploy
```

**Save your backend URL:**

```
Backend URL: https://tangiblex-backend.onrender.com
```

---

## Phase 8: Deploy Frontend

### Deploy to Vercel (Recommended)

1. Visit [Vercel](https://vercel.com/)
2. Import your GitHub repository
3. Configure:
   - **Framework Preset:** Vite
   - **Root Directory:** `frontend`
   - **Build Command:** `npm run build`
   - **Output Directory:** `dist`
4. Set Environment Variables:
   ```
   VITE_MANTLE_CHAIN_ID=5003
   VITE_API_BASE_URL=https://your-backend-url.onrender.com
   VITE_WALLETCONNECT_PROJECT_ID=your_project_id
   ```
5. Deploy

**Your live URL:**

```
Frontend URL: https://tangiblex.vercel.app
```

---

## Phase 9: Start Oracle Worker

The oracle worker needs to run continuously to update on-chain data.

### Option A: Run on Same Backend Service

Add to your backend's start script or use PM2:

```bash
# Install PM2
npm install -g pm2

# Start both processes
pm2 start src/index.js --name api
pm2 start src/oracle-worker/index.js --name oracle
pm2 save
```

### Option B: Separate Service

Deploy oracle worker as a separate background worker on Render/Railway.

---

## Phase 10: Initialize Platform

### 1. Register Test Assets

Use the admin panel or API to register your first asset:

```bash
curl -X POST http://localhost:3000/api/assets \
  -H "Content-Type: application/json" \
  -d '{
    "ipfsHash": "QmTestAsset",
    "assetType": 0,
    "totalValue": 1000000,
    "expectedYield": 500,
    "maturityDate": 1735689600,
    "metadata": "Test Real Estate Asset"
  }'
```

### 2. Grant Roles

Through the admin panel:
- Grant ISSUER role to asset creators
- Grant AUDITOR role to auditors
- Configure KYC manager

### 3. Test Complete Flow

1. Submit KYC documents
2. Admin verifies KYC
3. User browses marketplace
4. User invests in asset
5. Oracle updates yield
6. User claims yield

---

## Phase 11: Verification & Testing

### Smart Contracts

- ✅ All contracts deployed and verified on Mantle Sepolia
- ✅ View on explorer: https://sepolia.mantlescan.xyz/

### Backend

- ✅ API endpoints responding
- ✅ AI agent analyzing assets
- ✅ Oracle worker updating on-chain data

### Frontend

- ✅ Wallet connection works
- ✅ All pages render correctly
- ✅ Contract interactions work
- ✅ Real-time data updates

---

## Troubleshooting

### Contract Deployment Fails

```bash
# Check balance
cast balance $YOUR_ADDRESS --rpc-url https://rpc.sepolia.mantle.xyz

# Test RPC connection
cast block-number --rpc-url https://rpc.sepolia.mantle.xyz
```

### Backend Can't Connect to Contracts

- Verify contract addresses in .env
- Check RPC URL is correct
- Ensure private key has MNT balance

### Frontend Wallet Connection Issues

- Clear browser cache
- Ensure MetaMask is on Mantle Sepolia network
- Check WalletConnect Project ID is valid

### Oracle Worker Not Updating

- Check private key has MNT for gas
- Verify contract addresses are correct
- Check logs for errors

---

## Production Checklist

Before going to production:

- [ ] Use a secure private key management solution (AWS KMS, HashiCorp Vault)
- [ ] Set up monitoring and alerts
- [ ] Configure rate limiting on API
- [ ] Enable HTTPS everywhere
- [ ] Set up backup oracle workers
- [ ] Implement comprehensive error logging
- [ ] Set up automated contract monitoring
- [ ] Create incident response plan
- [ ] Get smart contracts professionally audited
- [ ] Implement multi-sig for admin functions

---

## Mainnet Deployment

When ready for Mantle Mainnet:

1. Update .env with mainnet values:
   ```env
   MANTLE_RPC_URL=https://rpc.mantle.xyz
   VITE_MANTLE_CHAIN_ID=5000
   ```

2. Get mainnet MNT tokens

3. Deploy contracts to mainnet:
   ```bash
   forge script script/Deploy.s.sol:DeployScript \
     --rpc-url https://rpc.mantle.xyz \
     --broadcast \
     --verify \
     -vvvv
   ```

4. Update all environment variables

5. Redeploy backend and frontend with mainnet config

---

## Support & Resources

- **Mantle Docs:** https://docs.mantle.xyz/
- **Foundry Book:** https://book.getfoundry.sh/
- **Viem Docs:** https://viem.sh/
- **Wagmi Docs:** https://wagmi.sh/

---

## Current Status

**✅ Development Complete:**
- Smart contracts: 5/5 implemented & tested (34 tests)
- Backend: 100% implemented
- Frontend: 100% implemented
- Documentation: Complete

**⏳ Pending:**
- Contract deployment to Mantle testnet (requires API keys)
- Backend/Frontend deployment (requires hosting accounts)
- End-to-end testing
- Demo video creation

**You're ready to deploy! Just need the API keys and credentials listed in Phase 1.**
