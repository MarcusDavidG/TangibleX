#!/bin/bash

# Export ABIs for frontend integration

echo "Exporting contract ABIs..."

mkdir -p frontend/src/contracts

cd contracts

forge inspect KYCManager abi > ../frontend/src/contracts/KYCManager.json
forge inspect AssetRegistry abi > ../frontend/src/contracts/AssetRegistry.json
forge inspect OracleUpdater abi > ../frontend/src/contracts/OracleUpdater.json
forge inspect YieldVault abi > ../frontend/src/contracts/YieldVault.json
forge inspect RWAERC20 abi > ../frontend/src/contracts/RWAERC20.json

echo "✅ ABIs exported to frontend/src/contracts/"
