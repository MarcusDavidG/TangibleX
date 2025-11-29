import { useAccount } from 'wagmi';
import { Wallet, TrendingUp, DollarSign } from 'lucide-react';

export default function Portfolio() {
  const { address, isConnected } = useAccount();

  if (!isConnected) {
    return (
      <div className="text-center py-12">
        <Wallet className="mx-auto h-12 w-12 text-gray-400" />
        <h3 className="mt-2 text-sm font-semibold text-gray-900">Connect Your Wallet</h3>
        <p className="mt-1 text-sm text-gray-500">
          Connect your wallet to view your portfolio
        </p>
      </div>
    );
  }

  return (
    <div className="px-4 sm:px-0">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">My Portfolio</h1>
        <p className="mt-2 text-sm text-gray-700">
          Track your RWA investments and yields
        </p>
      </div>

      <div className="grid grid-cols-1 gap-5 sm:grid-cols-3 mb-8">
        <StatCard
          icon={<DollarSign className="h-6 w-6" />}
          title="Total Invested"
          value="$0"
        />
        <StatCard
          icon={<TrendingUp className="h-6 w-6" />}
          title="Total Yield Earned"
          value="$0"
        />
        <StatCard
          icon={<Wallet className="h-6 w-6" />}
          title="Active Positions"
          value="0"
        />
      </div>

      <div className="bg-white shadow rounded-lg p-6">
        <h2 className="text-xl font-semibold text-gray-900 mb-4">Your Holdings</h2>
        <div className="text-center py-12">
          <p className="text-gray-500">No holdings yet</p>
          <p className="text-sm text-gray-400 mt-2">
            Start investing in tokenized assets to see your portfolio here
          </p>
        </div>
      </div>
    </div>
  );
}

function StatCard({ icon, title, value }) {
  return (
    <div className="bg-white overflow-hidden shadow rounded-lg">
      <div className="p-5">
        <div className="flex items-center">
          <div className="flex-shrink-0 bg-blue-500 rounded-md p-3 text-white">
            {icon}
          </div>
          <div className="ml-5 w-0 flex-1">
            <dl>
              <dt className="text-sm font-medium text-gray-500 truncate">{title}</dt>
              <dd className="text-2xl font-semibold text-gray-900">{value}</dd>
            </dl>
          </div>
        </div>
      </div>
    </div>
  );
}
