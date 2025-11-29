import express from 'express';
import { createPublicClient, http } from 'viem';
import { mantleSepoliaTestnet } from 'viem/chains';
import { contractAddresses, mantleConfig } from '../config/contracts.js';

const router = express.Router();

const publicClient = createPublicClient({
  chain: mantleSepoliaTestnet,
  transport: http(mantleConfig.rpcUrl),
});

const YIELD_VAULT_ABI = [
  {
    inputs: [
      { name: 'assetId', type: 'uint256' },
      { name: 'user', type: 'address' }
    ],
    name: 'getClaimableYield',
    outputs: [{ name: '', type: 'uint256' }],
    stateMutability: 'view',
    type: 'function'
  },
  {
    inputs: [{ name: '', type: 'uint256' }],
    name: 'yieldPools',
    outputs: [
      { name: 'rwaToken', type: 'address' },
      { name: 'totalYieldDeposited', type: 'uint256' },
      { name: 'totalYieldClaimed', type: 'uint256' },
      { name: 'lastDistributionTime', type: 'uint256' },
      { name: 'yieldRate', type: 'uint256' },
      { name: 'active', type: 'bool' }
    ],
    stateMutability: 'view',
    type: 'function'
  }
];

router.get('/claimable/:assetId/:address', async (req, res) => {
  try {
    const { assetId, address } = req.params;

    if (!contractAddresses.yieldVault) {
      return res.json({ claimable: '0', message: 'Contract not deployed yet' });
    }

    const claimable = await publicClient.readContract({
      address: contractAddresses.yieldVault,
      abi: YIELD_VAULT_ABI,
      functionName: 'getClaimableYield',
      args: [BigInt(assetId), address],
    });

    res.json({ claimable: claimable.toString() });
  } catch (error) {
    console.error('Error fetching claimable yield:', error);
    res.status(500).json({ error: error.message });
  }
});

router.get('/pool/:assetId', async (req, res) => {
  try {
    const { assetId } = req.params;

    if (!contractAddresses.yieldVault) {
      return res.json({ pool: null, message: 'Contract not deployed yet' });
    }

    const pool = await publicClient.readContract({
      address: contractAddresses.yieldVault,
      abi: YIELD_VAULT_ABI,
      functionName: 'yieldPools',
      args: [BigInt(assetId)],
    });

    res.json({ pool });
  } catch (error) {
    console.error('Error fetching yield pool:', error);
    res.status(500).json({ error: error.message });
  }
});

export default router;
