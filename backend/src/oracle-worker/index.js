import cron from 'node-cron';
import { createWalletClient, http, publicActions } from 'viem';
import { mantleSepoliaTestnet } from 'viem/chains';
import { privateKeyToAccount } from 'viem/accounts';
import dotenv from 'dotenv';
import AIAnalyzer from '../agents/ai-analyzer.js';

dotenv.config();

const account = privateKeyToAccount(`0x${process.env.PRIVATE_KEY}`);

const client = createWalletClient({
  account,
  chain: mantleSepoliaTestnet,
  transport: http(process.env.MANTLE_RPC_URL),
}).extend(publicActions);

const ORACLE_UPDATER_ABI = [
  {
    inputs: [
      { name: 'assetId', type: 'uint256' },
      { name: 'price', type: 'uint256' },
      { name: 'confidence', type: 'uint256' }
    ],
    name: 'updateAssetPrice',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function'
  },
  {
    inputs: [
      { name: 'assetId', type: 'uint256' },
      { name: 'score', type: 'uint256' },
      { name: 'reason', type: 'string' }
    ],
    name: 'updateRiskScore',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function'
  }
];

class OracleWorker {
  constructor() {
    this.oracleAddress = process.env.ORACLE_UPDATER_ADDRESS;
    this.assetRegistryAddress = process.env.ASSET_REGISTRY_ADDRESS;
  }

  async updatePrices() {
    console.log('🔄 Oracle: Updating asset prices...');
    
    try {
      const assetIds = [0, 1, 2];
      
      for (const assetId of assetIds) {
        const mockPrice = Math.floor(Math.random() * 1000000) + 500000;
        const confidence = Math.floor(Math.random() * 20) + 80;

        await this.updateAssetPrice(assetId, mockPrice, confidence);
        console.log(`✅ Updated price for asset ${assetId}: ${mockPrice} (confidence: ${confidence}%)`);
      }
    } catch (error) {
      console.error('❌ Price update error:', error.message);
    }
  }

  async updateRiskScores() {
    console.log('🔄 Oracle: Updating risk scores...');
    
    try {
      const assetIds = [0, 1, 2];
      
      for (const assetId of assetIds) {
        const mockAssetData = {
          assetType: Math.floor(Math.random() * 5),
          maturityDate: Date.now() + 365 * 24 * 60 * 60 * 1000,
          totalValue: 500000,
          issuer: '0x0000000000000000000000000000000000000000'
        };

        const riskScore = await AIAnalyzer.calculateRiskScore(mockAssetData);
        await this.updateAssetRiskScore(assetId, riskScore, 'AI-calculated risk assessment');
        console.log(`✅ Updated risk score for asset ${assetId}: ${riskScore}`);
      }
    } catch (error) {
      console.error('❌ Risk score update error:', error.message);
    }
  }

  async updateAssetPrice(assetId, price, confidence) {
    if (!this.oracleAddress) {
      console.log('⚠️  Oracle address not configured, skipping...');
      return;
    }

    const hash = await client.writeContract({
      address: this.oracleAddress,
      abi: ORACLE_UPDATER_ABI,
      functionName: 'updateAssetPrice',
      args: [BigInt(assetId), BigInt(price), BigInt(confidence)]
    });

    await client.waitForTransactionReceipt({ hash });
  }

  async updateAssetRiskScore(assetId, score, reason) {
    if (!this.oracleAddress) {
      console.log('⚠️  Oracle address not configured, skipping...');
      return;
    }

    const hash = await client.writeContract({
      address: this.oracleAddress,
      abi: ORACLE_UPDATER_ABI,
      functionName: 'updateRiskScore',
      args: [BigInt(assetId), BigInt(score), reason]
    });

    await client.waitForTransactionReceipt({ hash });
  }

  start() {
    console.log('🚀 Oracle Worker started');
    console.log(`📡 Connected to: ${process.env.MANTLE_RPC_URL}`);
    console.log(`📝 Oracle address: ${this.oracleAddress || 'Not configured'}`);

    cron.schedule('*/5 * * * *', () => {
      console.log('\n⏰ Running scheduled oracle updates...');
      this.updatePrices();
      this.updateRiskScores();
    });

    this.updatePrices();
    this.updateRiskScores();
  }
}

const worker = new OracleWorker();
worker.start();
