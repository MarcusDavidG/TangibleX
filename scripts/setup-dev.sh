#!/bin/bash

# Development environment setup script

echo "🚀 Setting up TangibleX development environment..."

# Check prerequisites
command -v node >/dev/null 2>&1 || { echo "❌ Node.js is required but not installed."; exit 1; }
command -v forge >/dev/null 2>&1 || { echo "❌ Foundry is required but not installed."; exit 1; }

# Install contract dependencies
echo "📦 Installing contract dependencies..."
cd contracts
forge install
cd ..

# Install backend dependencies
echo "📦 Installing backend dependencies..."
cd backend
npm install
cd ..

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd frontend
npm install
cd ..

# Copy .env.example to .env
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "⚠️  Please update .env with your actual values"
fi

echo "✅ Development environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env with your configuration"
echo "2. Run 'cd contracts && forge build' to compile contracts"
echo "3. Run 'cd backend && npm run dev' to start the backend"
echo "4. Run 'cd frontend && npm run dev' to start the frontend"
