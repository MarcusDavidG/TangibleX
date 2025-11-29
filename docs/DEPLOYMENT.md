# TangibleX Deployment Guide

This guide walks you through deploying TangibleX to production.

## Prerequisites

- Mantle Testnet MNT tokens
- OpenAI API key
- Pinata account (for IPFS)
- WalletConnect project ID
- Mantle Explorer API key (for verification)

## Step 1: Deploy Smart Contracts

### 1.1 Get Testnet Tokens

Visit https://faucet.sepolia.mantle.xyz/ and get MNT tokens for deployment.

### 1.2 Configure Environment

Create `contracts/.env`:
```bash
PRIVATE_KEY=your_private_key_without_0x
MANTLE_RPC_URL=https://rpc.sepolia.mantle.xyz
MANTLE_EXPLORER_API_KEY=your_api_key
```

### 1.3 Deploy

```bash
cd contracts
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url $MANTLE_RPC_URL \
  --broadcast \
  --verify \
  -vvvv
```

### 1.4 Save Contract Addresses

Copy the deployed addresses from console output and update your `.env` file.

## Step 2: Deploy Backend

### 2.1 Prepare Environment

Update `backend/.env` with deployed contract addresses.

### 2.2 Deploy to Render

1. Go to https://render.com
2. Create New → Web Service
3. Connect your GitHub repository
4. Configuration:
   - Name: tangiblex-backend
   - Environment: Node
   - Build Command: `cd backend && npm install`
   - Start Command: `cd backend && npm start`
5. Add all environment variables
6. Deploy

## Step 3: Deploy Frontend

### 3.1 Deploy to Vercel

1. Go to https://vercel.com
2. Import Project from GitHub
3. Configuration:
   - Framework Preset: Vite
   - Root Directory: frontend
   - Build Command: `npm run build`
   - Output Directory: dist
4. Add environment variables
5. Deploy

## Step 4: Initialize System

### 4.1 Grant Roles

Grant necessary roles to backend and oracle addresses for contract operations.

### 4.2 Create Test Assets

Register test assets to populate the marketplace.

For detailed instructions, see the full deployment documentation.
