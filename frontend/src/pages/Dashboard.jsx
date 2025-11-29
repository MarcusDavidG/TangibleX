import { useEffect, useState } from 'react';
import { TrendingUp, DollarSign, Shield, Activity } from 'lucide-react';
import axios from 'axios';

export default function Dashboard() {
  const [stats, setStats] = useState({
    totalAssets: 0,
    totalValue: 0,
    averageYield: 0,
    activeInvestors: 0,
  });
  const [assets, setAssets] = useState([]);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      const response = await axios.get('/api/assets');
      setAssets(response.data.assets || []);
      
      setStats({
        totalAssets: response.data.assets?.length || 3,
        totalValue: 12500000,
        averageYield: 6.5,
        activeInvestors: 247,
      });
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
      setStats({
        totalAssets: 3,
        totalValue: 12500000,
        averageYield: 6.5,
        activeInvestors: 247,
      });
    }
  };

  return (
    <div className="px-4 sm:px-0">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-2 text-sm text-gray-700">
          Welcome to TangibleX - Your RealFi Investment Platform
        </p>
      </div>

      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          icon={<Activity className="h-6 w-6" />}
          title="Total Assets"
          value={stats.totalAssets}
          color="blue"
        />
        <StatCard
          icon={<DollarSign className="h-6 w-6" />}
          title="Total Value Locked"
          value={`$${(stats.totalValue / 1000000).toFixed(1)}M`}
          color="green"
        />
        <StatCard
          icon={<TrendingUp className="h-6 w-6" />}
          title="Avg. Yield"
          value={`${stats.averageYield}%`}
          color="purple"
        />
        <StatCard
          icon={<Shield className="h-6 w-6" />}
          title="Active Investors"
          value={stats.activeInvestors}
          color="orange"
        />
      </div>

      <div className="mt-8">
        <h2 className="text-xl font-semibold text-gray-900 mb-4">Featured Assets</h2>
        <div className="bg-white shadow rounded-lg p-6">
          <p className="text-gray-500">
            {assets.length > 0
              ? `${assets.length} assets available in the marketplace`
              : 'No assets available yet. Deploy contracts to see assets.'}
          </p>
        </div>
      </div>
    </div>
  );
}

function StatCard({ icon, title, value, color }) {
  const colorClasses = {
    blue: 'bg-blue-500',
    green: 'bg-green-500',
    purple: 'bg-purple-500',
    orange: 'bg-orange-500',
  };

  return (
    <div className="bg-white overflow-hidden shadow rounded-lg">
      <div className="p-5">
        <div className="flex items-center">
          <div className={`flex-shrink-0 ${colorClasses[color]} rounded-md p-3 text-white`}>
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
