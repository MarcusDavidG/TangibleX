#!/bin/bash

# Smart contract deployment script for Mantle Sepolia

echo "🚀 Deploying TangibleX contracts to Mantle Sepolia..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ .env file not found. Please create one with PRIVATE_KEY and MANTLE_RPC_URL"
    exit 1
fi

# Load environment variables
source .env

# Check required variables
if [ -z "$PRIVATE_KEY" ] || [ -z "$MANTLE_RPC_URL" ]; then
    echo "❌ Missing required environment variables (PRIVATE_KEY, MANTLE_RPC_URL)"
    exit 1
fi

cd contracts

# Build contracts
echo "📦 Building contracts..."
forge build

if [ $? -ne 0 ]; then
    echo "❌ Contract build failed"
    exit 1
fi

# Run tests
echo "🧪 Running tests..."
forge test

if [ $? -ne 0 ]; then
    echo "❌ Tests failed"
    exit 1
fi

# Deploy contracts
echo "🚀 Deploying to Mantle Sepolia..."
forge script script/Deploy.s.sol:DeployScript \
    --rpc-url $MANTLE_RPC_URL \
    --broadcast \
    --verify \
    -vvvv

if [ $? -eq 0 ]; then
    echo "✅ Deployment complete!"
    echo "📝 Don't forget to update .env with the deployed contract addresses"
else
    echo "❌ Deployment failed"
    exit 1
fi
