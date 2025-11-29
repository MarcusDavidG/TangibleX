import dotenv from 'dotenv';
dotenv.config();

export const contractAddresses = {
  kycManager: process.env.KYC_MANAGER_ADDRESS,
  assetRegistry: process.env.ASSET_REGISTRY_ADDRESS,
  oracleUpdater: process.env.ORACLE_UPDATER_ADDRESS,
  yieldVault: process.env.YIELD_VAULT_ADDRESS,
};

export const mantleConfig = {
  rpcUrl: process.env.MANTLE_RPC_URL || 'https://rpc.sepolia.mantle.xyz',
  chainId: 5003,
  explorerUrl: 'https://sepolia.mantlescan.xyz',
};

export const ipfsConfig = {
  pinataApiKey: process.env.PINATA_API_KEY,
  pinataSecretKey: process.env.PINATA_SECRET_KEY,
};
