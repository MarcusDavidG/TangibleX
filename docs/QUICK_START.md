# TangibleX Quick Start Guide

Get TangibleX running in **5 minutes** (for development) or **30 minutes** (for full deployment).

---

## 🚀 Current Status

✅ **ALL DEVELOPMENT COMPLETE!**

- ✅ Smart Contracts: 5/5 implemented
- ✅ Tests: 34/34 passing (100% success rate)
- ✅ Backend: Fully implemented (Express + AI + Oracle)
- ✅ Frontend: Fully implemented (React + Wagmi + TailwindCSS)
- ✅ Dependencies: All installed
- ✅ Configuration: .env file created

**You are at 60% completion. Next: Deploy to Mantle testnet!**

---

## 🎯 Choose Your Path

### Path A: Local Development (No deployment needed)

Perfect for testing, development, and understanding the codebase.

**Time:** 5 minutes

```bash
# 1. Test smart contracts
cd contracts
forge test -vv
# ✅ 34 tests should pass

# 2. Start backend (mocked mode)
cd ../backend
npm run dev
# ✅ Server runs on http://localhost:3000

# 3. Start frontend
cd ../frontend
npm run dev
# ✅ App runs on http://localhost:5173
```

**Note:** Without deployed contracts, the app will show "Contract not deployed yet" messages. This is expected!

---

### Path B: Full Deployment to Mantle Testnet

Complete deployment with live contracts on Mantle Sepolia.

**Time:** 30 minutes  
**Requirements:**
- Mantle Sepolia MNT tokens (free from faucet)
- OpenAI API key (free tier available)
- Pinata API keys (free tier available)
- WalletConnect Project ID (free)

**Follow:** [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

---

## 📋 Pre-Deployment Checklist

Before deploying, you need:

### 1. Testnet Tokens
- [ ] Get MNT from [Mantle Sepolia Faucet](https://faucet.sepolia.mantle.xyz/)

### 2. API Keys
- [ ] OpenAI API Key: [Get it here](https://platform.openai.com/api-keys)
- [ ] Pinata API Keys: [Get them here](https://app.pinata.cloud/)
- [ ] WalletConnect ID: [Get it here](https://cloud.walletconnect.com/)

### 3. Update .env File
- [ ] Add your private key (test wallet only!)
- [ ] Add all API keys
- [ ] Keep contract addresses empty (filled after deployment)

---

## 🔥 One-Command Deployment (After Prerequisites)

Once you have all API keys configured in `.env`:

```bash
# From project root
./scripts/deploy-contracts.sh
```

This will:
1. ✅ Compile contracts
2. ✅ Run all tests
3. ✅ Deploy to Mantle Sepolia
4. ✅ Update .env with addresses
5. ✅ Export ABIs to frontend

---

## 📊 Project Structure

```
tangiblex/
├── contracts/          # Smart contracts (Foundry)
│   ├── src/           # 5 contracts (KYC, Asset, Token, Vault, Oracle)
│   ├── test/          # 34 tests (all passing)
│   └── script/        # Deployment scripts
├── backend/           # Express API + AI + Oracle
│   ├── src/
│   │   ├── api/       # REST endpoints
│   │   ├── agents/    # AI analyzer (OpenAI)
│   │   ├── oracle-worker/  # On-chain updater
│   │   └── config/    # Configuration
│   └── package.json
├── frontend/          # React + Vite + Wagmi
│   ├── src/
│   │   ├── pages/     # 6 pages (Dashboard, Marketplace, etc.)
│   │   ├── components/
│   │   └── lib/       # Wagmi config for Mantle
│   └── package.json
├── scripts/           # Automation scripts
├── docs/             # Documentation
├── .env              # Configuration (fill this!)
└── README.md
```

---

## 🧪 Testing

### Smart Contracts

```bash
cd contracts

# Run all tests
forge test -vv

# Run with gas reporting
forge test --gas-report

# Run specific test
forge test --match-test testMintToKYCVerifiedUser -vvv
```

**Current Status:** ✅ 34/34 tests passing

### Backend API

```bash
cd backend

# Start server
npm run dev

# In another terminal, test endpoints:
curl http://localhost:3000/health
curl http://localhost:3000/api/assets
```

### Frontend

```bash
cd frontend

# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

---

## 🎨 Accessing the App

### Local Development

- **Frontend:** http://localhost:5173
- **Backend API:** http://localhost:3000
- **API Health:** http://localhost:3000/health

### After Deployment

- **Frontend:** https://your-app.vercel.app
- **Backend:** https://your-api.onrender.com
- **Contracts:** https://sepolia.mantlescan.xyz/

---

## 📖 Available API Endpoints

### Assets
- `GET /api/assets` - List all assets
- `GET /api/assets/:assetId` - Get asset details

### Analysis (AI-Powered)
- `POST /api/analysis/document` - Analyze asset document
- `POST /api/analysis/risk-score` - Calculate risk score
- `POST /api/analysis/yield-prediction` - Predict yield

### KYC
- `POST /api/kyc/submit` - Submit KYC document
- `GET /api/kyc/status/:address` - Check KYC status

### Yield
- `GET /api/yield/claimable/:assetId/:address` - Get claimable yield
- `GET /api/yield/pool/:assetId` - Get yield pool info

---

## 🔧 Common Commands

```bash
# Smart Contracts
cd contracts
forge build          # Compile contracts
forge test          # Run tests
forge coverage      # Check test coverage
forge clean         # Clean build artifacts

# Backend
cd backend
npm run dev         # Development mode with auto-reload
npm start           # Production mode
npm run oracle      # Start oracle worker

# Frontend
cd frontend
npm run dev         # Development server
npm run build       # Build for production
npm run preview     # Preview production build
npm run lint        # Check code quality
```

---

## 🐛 Troubleshooting

### "Cannot find module" errors

```bash
# Reinstall dependencies
cd backend && npm install
cd ../frontend && npm install
```

### Forge tests fail

```bash
# Clean and rebuild
cd contracts
forge clean
forge build
forge test -vv
```

### Frontend can't connect to contracts

1. Make sure contracts are deployed
2. Check .env has correct addresses
3. Verify you're on Mantle Sepolia network in MetaMask

### Backend API errors

1. Check .env file is in project root (not in backend/)
2. Verify contract addresses are set
3. Check RPC URL is accessible

---

## 📚 Next Steps

### For Development

1. **Explore the codebase**
   - Read smart contracts in `contracts/src/`
   - Check backend APIs in `backend/src/api/`
   - Review frontend pages in `frontend/src/pages/`

2. **Modify and test**
   - Change contract logic
   - Add new API endpoints
   - Customize UI components

### For Deployment

1. **Get API keys** (see checklist above)
2. **Update .env file** with real values
3. **Follow deployment guide:** [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
4. **Deploy contracts** to Mantle testnet
5. **Deploy backend** to Render/Railway
6. **Deploy frontend** to Vercel
7. **Test end-to-end**

### For Hackathon Submission

1. **Record demo video** (3-5 minutes)
   - Show platform features
   - Demonstrate AI analysis
   - Show yield distribution
   
2. **Prepare 1-pager** with:
   - Project overview
   - Key features
   - Technical architecture
   - Mantle integration details

3. **Submit to hackathon** with:
   - GitHub repository link
   - Deployed app URL
   - Demo video
   - Documentation

---

## 🎯 You Are Here

```
[✅ Development] → [⏳ Deployment] → [⏭️ Production]
     100%              0%              0%

Your current progress: 60% overall
```

**Next immediate task:** Get API keys and deploy contracts!

---

## 💡 Tips

- **Test locally first** before deploying
- **Use a test wallet** with small amounts only
- **Check Mantle faucet** if transactions fail (need more MNT)
- **Monitor gas usage** on testnet
- **Save all contract addresses** immediately after deployment
- **Verify contracts** on explorer for transparency

---

## 🆘 Getting Help

- **Mantle Docs:** https://docs.mantle.xyz/
- **Foundry Book:** https://book.getfoundry.sh/
- **Wagmi Docs:** https://wagmi.sh/
- **Viem Docs:** https://viem.sh/

---

**Ready to deploy? Start with Path B above or follow the [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)!**
