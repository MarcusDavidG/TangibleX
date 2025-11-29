import express from 'express';
import { createPublicClient, http } from 'viem';
import { mantleSepoliaTestnet } from 'viem/chains';
import { contractAddresses, mantleConfig } from '../config/contracts.js';

const router = express.Router();

const publicClient = createPublicClient({
  chain: mantleSepoliaTestnet,
  transport: http(mantleConfig.rpcUrl),
});

const ASSET_REGISTRY_ABI = [
  {
    inputs: [{ name: 'assetId', type: 'uint256' }],
    name: 'getAsset',
    outputs: [{
      components: [
        { name: 'ipfsHash', type: 'string' },
        { name: 'assetType', type: 'uint8' },
        { name: 'status', type: 'uint8' },
        { name: 'issuer', type: 'address' },
        { name: 'tokenAddress', type: 'address' },
        { name: 'totalValue', type: 'uint256' },
        { name: 'maturityDate', type: 'uint256' },
        { name: 'createdAt', type: 'uint256' },
        { name: 'expectedYield', type: 'uint256' },
        { name: 'metadata', type: 'string' }
      ],
      type: 'tuple'
    }],
    stateMutability: 'view',
    type: 'function'
  },
  {
    inputs: [],
    name: 'getActiveAssets',
    outputs: [{ name: '', type: 'uint256[]' }],
    stateMutability: 'view',
    type: 'function'
  },
  {
    inputs: [],
    name: 'assetCount',
    outputs: [{ name: '', type: 'uint256' }],
    stateMutability: 'view',
    type: 'function'
  }
];

router.get('/', async (req, res) => {
  try {
    if (!contractAddresses.assetRegistry) {
      return res.json({ assets: [], message: 'Contract not deployed yet' });
    }

    const activeAssets = await publicClient.readContract({
      address: contractAddresses.assetRegistry,
      abi: ASSET_REGISTRY_ABI,
      functionName: 'getActiveAssets',
    });

    const assetsDetails = await Promise.all(
      activeAssets.map(assetId =>
        publicClient.readContract({
          address: contractAddresses.assetRegistry,
          abi: ASSET_REGISTRY_ABI,
          functionName: 'getAsset',
          args: [assetId],
        })
      )
    );

    res.json({ assets: assetsDetails });
  } catch (error) {
    console.error('Error fetching assets:', error);
    res.status(500).json({ error: error.message });
  }
});

router.get('/:assetId', async (req, res) => {
  try {
    const { assetId } = req.params;

    if (!contractAddresses.assetRegistry) {
      return res.status(404).json({ error: 'Contract not deployed yet' });
    }

    const asset = await publicClient.readContract({
      address: contractAddresses.assetRegistry,
      abi: ASSET_REGISTRY_ABI,
      functionName: 'getAsset',
      args: [BigInt(assetId)],
    });

    res.json({ asset });
  } catch (error) {
    console.error('Error fetching asset:', error);
    res.status(500).json({ error: error.message });
  }
});

export default router;
