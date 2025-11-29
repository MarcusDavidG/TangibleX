# 🎯 TangibleX - Deployment Status

**Last Updated:** November 28, 2025

---

## ✅ COMPLETED - Ready for Deployment!

- [x] ✅ All smart contracts written and tested (34/34 tests passing)
- [x] ✅ Backend API fully implemented
- [x] ✅ Frontend application complete
- [x] ✅ All dependencies installed (1.4GB)
- [x] ✅ Deployment scripts created
- [x] ✅ Documentation complete (7 guides)
- [x] ✅ .env template created
- [x] ✅ Contracts compile successfully

---

## 🔑 WHAT YOU NEED NOW (API Keys)

To deploy, you need these API keys. All have FREE tiers:

### 1. Wallet with Mantle Sepolia MNT ⚠️ REQUIRED
**Status:** ❌ Need to configure
**Time:** 5 minutes
**Actions:**
```bash
# Option 1: Create new test wallet
cast wallet new

# Option 2: Use existing MetaMask wallet
# Export private key from MetaMask
```

**Get testnet MNT:**
- Visit: https://faucet.sepolia.mantle.xyz/
- Request tokens (FREE)
- Takes ~1 minute

---

### 2. OpenAI API Key ⚠️ REQUIRED
**Status:** ❌ Need to configure
**Time:** 3 minutes
**Cost:** FREE ($5 credit included)

**Get it:**
1. Visit: https://platform.openai.com/signup
2. Create account
3. Go to: https://platform.openai.com/api-keys
4. Click "Create new secret key"
5. Copy key (starts with `sk-proj-...`)

---

### 3. WalletConnect Project ID ⚠️ REQUIRED
**Status:** ❌ Need to configure
**Time:** 2 minutes
**Cost:** FREE

**Get it:**
1. Visit: https://cloud.walletconnect.com/
2. Sign up / Log in
3. Create new project
4. Copy Project ID

---

### 4. Pinata API Keys (OPTIONAL)
**Status:** ❌ Optional for now
**Time:** 2 minutes
**Cost:** FREE (1GB storage)

**Get it:**
1. Visit: https://app.pinata.cloud/
2. Sign up
3. Create API key
4. Copy API Key + Secret

**Note:** You can skip this for now and add it later.

---

## 🚀 DEPLOYMENT STEPS

Once you have the keys above, deployment takes ~30 minutes:

### Phase 1: Configure Environment (5 min)
```bash
# Edit .env file
nano /home/marcus/TangibleX/.env

# Add your keys:
# - PRIVATE_KEY=your_actual_key
# - OPENAI_API_KEY=sk-proj-...
# - VITE_WALLETCONNECT_PROJECT_ID=...
```

### Phase 2: Deploy Contracts (5 min)
```bash
cd /home/marcus/TangibleX/contracts
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url https://rpc.sepolia.mantle.xyz \
  --broadcast \
  -vvvv
```

### Phase 3: Export ABIs (1 min)
```bash
cd /home/marcus/TangibleX
./scripts/export-abis.sh
```

### Phase 4: Test Locally (5 min)
```bash
# Terminal 1: Backend
cd backend && npm run dev

# Terminal 2: Frontend
cd frontend && npm run dev

# Terminal 3: Test
curl http://localhost:3000/health
```

### Phase 5: Deploy to Hosting (15 min)
- Deploy backend to Render (free)
- Deploy frontend to Vercel (free)
- Deploy oracle worker (free)

### Phase 6: Final Testing (5 min)
- Test live deployment
- Verify all features work

---

## 📊 Deployment Checklist

### Pre-Deployment
- [ ] Get Mantle Sepolia MNT tokens
- [ ] Get OpenAI API key
- [ ] Get WalletConnect Project ID
- [ ] Get Pinata keys (optional)
- [ ] Update .env file with keys

### Contract Deployment
- [ ] Deploy contracts to Mantle Sepolia
- [ ] Save contract addresses
- [ ] Verify contracts on explorer
- [ ] Export ABIs to frontend
- [ ] Update .env with addresses

### Local Testing
- [ ] Test backend API
- [ ] Test frontend locally
- [ ] Test wallet connection
- [ ] Verify contract interactions

### Live Deployment
- [ ] Deploy backend to Render
- [ ] Deploy frontend to Vercel
- [ ] Deploy oracle worker
- [ ] Update frontend API URL
- [ ] Test live deployment

### Demo & Submission
- [ ] Record demo video (3-5 min)
- [ ] Fill submission form
- [ ] Submit to hackathon

---

## 🎬 Quick Start Commands

### Generate Test Wallet
```bash
cast wallet new
# Save the private key and address!
```

### Check Wallet Balance
```bash
cast balance YOUR_ADDRESS --rpc-url https://rpc.sepolia.mantle.xyz
```

### Deploy Everything
```bash
# 1. Update .env first!
nano /home/marcus/TangibleX/.env

# 2. Run deployment
cd /home/marcus/TangibleX
./scripts/deploy-contracts.sh

# 3. Export ABIs
./scripts/export-abis.sh

# 4. Test locally
cd backend && npm run dev
# In another terminal:
cd frontend && npm run dev
```

---

## 🆘 Need Help?

**Read these guides:**
- 📖 Quick overview: `cat DEPLOY_NOW.md`
- 📖 Full guide: `cat docs/DEPLOYMENT_GUIDE.md`
- 📖 Troubleshooting: `cat docs/QUICK_START.md`

**Check compilation:**
```bash
cd contracts && forge build
```

**Run tests:**
```bash
cd contracts && forge test -vv
```

---

## ⏱️ Time Estimates

| Task | Time | Status |
|------|------|--------|
| Get API keys | 10 min | ⏳ Pending |
| Configure .env | 3 min | ⏳ Pending |
| Deploy contracts | 5 min | ⏳ Pending |
| Test locally | 5 min | ⏳ Pending |
| Deploy services | 15 min | ⏳ Pending |
| Create demo video | 60 min | ⏳ Pending |
| Submit | 5 min | ⏳ Pending |
| **TOTAL** | **~2 hours** | **⏳ Ready to start!** |

---

## 🎯 NEXT STEPS

### Immediate (Right Now):

**Option A: Use existing wallet**
If you have MetaMask with testnet MNT:
```bash
# Export private key from MetaMask
# Update .env with that key
nano /home/marcus/TangibleX/.env
```

**Option B: Create new wallet**
```bash
# Generate new wallet
cast wallet new

# Copy the private key
# Get testnet MNT from faucet
# Update .env
nano /home/marcus/TangibleX/.env
```

### Then:

1. **Get OpenAI key** → https://platform.openai.com/api-keys
2. **Get WalletConnect ID** → https://cloud.walletconnect.com/
3. **Update .env** with all keys
4. **Deploy contracts** → Run `./scripts/deploy-contracts.sh`

---

## 💪 You're Almost There!

**Development:** 100% ✅  
**Deployment:** 0% ⏳ (waiting on API keys)  
**Total Progress:** 70% complete

**What's blocking deployment:** Just need API keys (takes 10 minutes to get)

**Once you have keys:** Deployment is automated and takes ~30 minutes

---

## 📞 What Do You Want to Do?

Tell me which option:

**A)** "I have a MetaMask wallet" → I'll help you export the key and get testnet MNT

**B)** "I want to create a new test wallet" → I'll generate one for you now

**C)** "I already have all the API keys" → Great! Let's deploy right now

**D)** "I need help getting the API keys" → I'll guide you through each one

---

**Which option? Let me know and we'll proceed!** 🚀
