# 🚀 TangibleX Deployment - Step by Step

**Status:** Ready to deploy! Follow these steps in order.

---

## 📋 Pre-Deployment Checklist

Before we deploy, you need to get API keys. Here's what you need:

### 1. 🔑 Wallet & Testnet Tokens (REQUIRED for contract deployment)

**Option A: Use an existing test wallet**
- If you have MetaMask with a test wallet, export the private key
- Make sure it has Mantle Sepolia MNT tokens

**Option B: Create a new test wallet**
```bash
# Generate a new wallet using cast (Foundry)
cast wallet new

# This will output:
# - Address: 0x...
# - Private key: 0x...
```

**Get testnet MNT:**
1. Visit: https://faucet.sepolia.mantle.xyz/
2. Connect your wallet or paste your address
3. Request testnet MNT tokens
4. Wait ~1 minute for confirmation

**⚠️ SECURITY NOTE:** Only use a test wallet! Never use your main wallet private key!

---

### 2. 🤖 OpenAI API Key (REQUIRED for AI features)

**Free tier available! $5 in free credits when you sign up.**

1. Visit: https://platform.openai.com/signup
2. Create an account (or log in)
3. Go to: https://platform.openai.com/api-keys
4. Click "Create new secret key"
5. Copy the key (starts with `sk-proj-...`)

**Cost:** ~$0.002 per risk analysis (free tier covers 2,500 analyses)

---

### 3. 📌 Pinata API Keys (OPTIONAL - for IPFS)

**Free tier: 1GB storage, 100k requests/month**

1. Visit: https://app.pinata.cloud/
2. Sign up for free account
3. Go to API Keys section
4. Click "New Key"
5. Copy both:
   - API Key
   - API Secret

**Note:** You can skip this initially and add it later. Documents will just be stored as hashes.

---

### 4. 🔌 WalletConnect Project ID (REQUIRED for frontend)

**Free tier available!**

1. Visit: https://cloud.walletconnect.com/
2. Sign up / Log in
3. Create a new project
4. Copy the Project ID

---

## 🎯 Quick Deploy (If you have all keys ready)

If you already have all the API keys, run this:

```bash
# 1. Update .env with your keys
nano /home/marcus/TangibleX/.env

# 2. Deploy contracts
cd /home/marcus/TangibleX
./scripts/deploy-contracts.sh

# 3. Export ABIs
./scripts/export-abis.sh

# 4. Test locally
cd backend && npm run dev &
cd frontend && npm run dev
```

---

## 📝 Step-by-Step Deployment

### Step 1: Configure Environment Variables

Edit the .env file:

```bash
nano /home/marcus/TangibleX/.env
```

Replace these placeholder values:

```env
# Replace this with your actual private key (without 0x prefix)
PRIVATE_KEY=abc123def456...  # Your actual private key

# These can stay as is (they're correct)
MANTLE_RPC_URL=https://rpc.sepolia.mantle.xyz
MANTLE_EXPLORER_API_KEY=your_explorer_api_key  # Optional for verification

# Replace with your OpenAI key
OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxx  # Your actual OpenAI key

# Optional - can skip initially
PINATA_API_KEY=your_actual_pinata_key
PINATA_SECRET_KEY=your_actual_pinata_secret

# Replace with your WalletConnect Project ID
VITE_WALLETCONNECT_PROJECT_ID=abc123def456...  # Your actual Project ID
```

**Save and exit:** Press `Ctrl+X`, then `Y`, then `Enter`

---

### Step 2: Verify Your Setup

Check that your wallet has testnet MNT:

```bash
# Check your balance
cast balance <YOUR_ADDRESS> --rpc-url https://rpc.sepolia.mantle.xyz

# Should show something like: 1000000000000000000 (1 MNT in wei)
```

---

### Step 3: Deploy Smart Contracts

```bash
cd /home/marcus/TangibleX/contracts

# Deploy to Mantle Sepolia
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url https://rpc.sepolia.mantle.xyz \
  --broadcast \
  -vvvv
```

**Expected output:**
```
KYCManager deployed at: 0x1234...
AssetRegistry deployed at: 0x5678...
OracleUpdater deployed at: 0x9abc...
YieldVault deployed at: 0xdef0...
```

**⚠️ IMPORTANT:** Copy these addresses! You'll need them in the next step.

---

### Step 4: Update .env with Contract Addresses

Edit .env again and add the deployed addresses:

```bash
nano /home/marcus/TangibleX/.env
```

Update these lines:
```env
KYC_MANAGER_ADDRESS=0x1234...  # Paste your actual addresses here
ASSET_REGISTRY_ADDRESS=0x5678...
ORACLE_UPDATER_ADDRESS=0x9abc...
YIELD_VAULT_ADDRESS=0xdef0...
```

---

### Step 5: Verify Contracts (Optional but Recommended)

```bash
cd /home/marcus/TangibleX/contracts

# Get your explorer API key from https://sepolia.mantlescan.xyz/
# Then verify each contract:

forge verify-contract <KYC_MANAGER_ADDRESS> src/KYCManager.sol:KYCManager \
  --chain mantle-sepolia \
  --watch

# Repeat for other contracts
```

---

### Step 6: Export ABIs to Frontend

```bash
cd /home/marcus/TangibleX
./scripts/export-abis.sh
```

**Expected output:**
```
✅ ABIs exported to frontend/src/contracts/
```

---

### Step 7: Test Backend Locally

```bash
cd /home/marcus/TangibleX/backend
npm run dev
```

**Expected output:**
```
🚀 TangibleX Backend running on port 3000
📊 Health check: http://localhost:3000/health
```

**Test it:**
```bash
# In another terminal:
curl http://localhost:3000/health
# Should return: {"status":"ok","timestamp":...}
```

---

### Step 8: Test Frontend Locally

```bash
cd /home/marcus/TangibleX/frontend
npm run dev
```

**Expected output:**
```
  VITE v5.x.x  ready in xxx ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

**Open in browser:** http://localhost:5173

**Test checklist:**
- [ ] Page loads without errors
- [ ] Wallet connect button appears
- [ ] Can connect MetaMask
- [ ] Network switches to Mantle Sepolia
- [ ] All pages navigate correctly

---

### Step 9: Deploy Backend to Render

1. **Sign up:** https://render.com/
2. **Create Web Service:**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select the TangibleX repo

3. **Configure:**
   - Name: `tangiblex-backend`
   - Root Directory: `backend`
   - Build Command: `npm install`
   - Start Command: `npm start`
   - Instance Type: Free

4. **Environment Variables:**
   Add all variables from your .env file:
   ```
   PRIVATE_KEY=...
   MANTLE_RPC_URL=https://rpc.sepolia.mantle.xyz
   OPENAI_API_KEY=...
   PINATA_API_KEY=...
   PINATA_SECRET_KEY=...
   KYC_MANAGER_ADDRESS=...
   ASSET_REGISTRY_ADDRESS=...
   ORACLE_UPDATER_ADDRESS=...
   YIELD_VAULT_ADDRESS=...
   PORT=3000
   NODE_ENV=production
   ```

5. **Deploy!**
   - Click "Create Web Service"
   - Wait for deployment (~5 minutes)
   - Copy your backend URL: `https://tangiblex-backend.onrender.com`

---

### Step 10: Deploy Frontend to Vercel

1. **Sign up:** https://vercel.com/
2. **Import Project:**
   - Click "Add New..." → "Project"
   - Import from GitHub
   - Select TangibleX repository

3. **Configure:**
   - Framework Preset: Vite
   - Root Directory: `frontend`
   - Build Command: `npm run build`
   - Output Directory: `dist`

4. **Environment Variables:**
   ```
   VITE_MANTLE_CHAIN_ID=5003
   VITE_API_BASE_URL=https://tangiblex-backend.onrender.com
   VITE_WALLETCONNECT_PROJECT_ID=your_project_id
   ```

5. **Deploy!**
   - Click "Deploy"
   - Wait for deployment (~3 minutes)
   - Copy your frontend URL: `https://tangiblex.vercel.app`

---

### Step 11: Start Oracle Worker

The oracle worker needs to run continuously. Deploy it on Render:

1. **Create Background Worker:**
   - New → Background Worker
   - Use same repository
   - Root Directory: `backend`
   - Build Command: `npm install`
   - Start Command: `npm run oracle`

2. **Set same environment variables as backend**

3. **Deploy**

---

### Step 12: End-to-End Testing

Test your live deployment:

1. **Visit your frontend:** `https://tangiblex.vercel.app`
2. **Connect wallet** (MetaMask with Mantle Sepolia)
3. **Test each page:**
   - [ ] Dashboard shows correct data
   - [ ] Marketplace loads
   - [ ] Can submit KYC
   - [ ] Portfolio displays
   - [ ] Admin panel accessible

4. **Test transactions:**
   - [ ] Register a test asset (via admin panel)
   - [ ] Mint tokens
   - [ ] Check yield calculations

---

## 🎥 Step 13: Create Demo Video

**Tools:** OBS Studio, Loom, or screen recording

**Script (3-5 minutes):**

1. **Intro (30s):**
   - "Hi, I'm [name], this is TangibleX"
   - "A RealFi platform on Mantle Network"
   - Show homepage

2. **Tech Overview (60s):**
   - Show contracts on Mantle Sepolia explorer
   - Explain AI + Oracle architecture
   - Highlight Mantle integration

3. **Live Demo (120s):**
   - Connect wallet
   - Browse marketplace
   - Submit KYC
   - View AI risk analysis
   - Show yield distribution

4. **Conclusion (30s):**
   - Key features recap
   - "Built on Mantle Network"
   - Thank you

**Upload to:** YouTube (unlisted) or Loom

---

## 📝 Step 14: Complete Hackathon Submission

Use the template in `/home/marcus/TangibleX/docs/HACKATHON_SUBMISSION.md`

**Fill in:**
- [ ] Deployed contract addresses
- [ ] Frontend URL
- [ ] Backend URL
- [ ] Demo video link
- [ ] Your contact info

**Submit to hackathon platform!**

---

## ❓ Troubleshooting

### "Insufficient funds" error
- Get more testnet MNT from faucet
- Check balance: `cast balance <ADDRESS> --rpc-url https://rpc.sepolia.mantle.xyz`

### "Invalid private key" error
- Make sure private key is without "0x" prefix
- Check for extra spaces in .env file

### Backend can't connect to contracts
- Verify contract addresses in .env are correct
- Check RPC URL is accessible
- Ensure private key has MNT balance

### Frontend wallet connection fails
- Check WalletConnect Project ID is valid
- Clear browser cache
- Try different wallet (MetaMask, Rainbow, etc.)

### Oracle worker not updating
- Check it's running (Render dashboard)
- Verify contract addresses are correct
- Check logs for errors
- Ensure wallet has MNT for gas

---

## 🎯 Current Status

**Run this to check what you've completed:**

```bash
cd /home/marcus/TangibleX

# Check if contracts are deployed
if [ -z "$KYC_MANAGER_ADDRESS" ]; then
  echo "❌ Contracts not deployed yet"
else
  echo "✅ Contracts deployed"
fi

# Check if backend is running
curl -s http://localhost:3000/health && echo "✅ Backend running" || echo "❌ Backend not running"

# Check if frontend is accessible
curl -s http://localhost:5173 && echo "✅ Frontend running" || echo "❌ Frontend not running"
```

---

## 🚀 Quick Commands Reference

```bash
# Test contracts
cd contracts && forge test -vv

# Deploy contracts
cd contracts && forge script script/Deploy.s.sol:DeployScript --rpc-url https://rpc.sepolia.mantle.xyz --broadcast -vvvv

# Export ABIs
cd .. && ./scripts/export-abis.sh

# Start backend
cd backend && npm run dev

# Start frontend
cd frontend && npm run dev

# Check balance
cast balance <ADDRESS> --rpc-url https://rpc.sepolia.mantle.xyz
```

---

**Ready? Let's start with Step 1: Getting your API keys!**

**Which keys do you already have?**
- [ ] Wallet with testnet MNT
- [ ] OpenAI API key
- [ ] Pinata API keys (optional)
- [ ] WalletConnect Project ID

Let me know what you have, and I'll help you get the rest!
