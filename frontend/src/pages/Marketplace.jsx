import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';
import { TrendingUp, Calendar, DollarSign } from 'lucide-react';

export default function Marketplace() {
  const [assets, setAssets] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchAssets();
  }, []);

  const fetchAssets = async () => {
    try {
      const response = await axios.get('/api/assets');
      setAssets(response.data.assets || []);
    } catch (error) {
      console.error('Error fetching assets:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="text-center py-12">Loading assets...</div>;
  }

  return (
    <div className="px-4 sm:px-0">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Asset Marketplace</h1>
        <p className="mt-2 text-sm text-gray-700">
          Browse and invest in tokenized real-world assets
        </p>
      </div>

      {assets.length === 0 ? (
        <div className="bg-white shadow rounded-lg p-12 text-center">
          <p className="text-gray-500 mb-4">No assets available yet.</p>
          <p className="text-sm text-gray-400">
            Deploy the smart contracts and register assets to see them here.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {assets.map((asset, index) => (
            <AssetCard key={index} asset={asset} assetId={index} />
          ))}
        </div>
      )}
    </div>
  );
}

function AssetCard({ asset, assetId }) {
  const assetTypes = ['Real Estate', 'Invoice', 'Bond', 'Loan', 'Other'];
  const assetType = assetTypes[asset[1]] || 'Unknown';

  return (
    <Link to={`/asset/${assetId}`}>
      <div className="bg-white rounded-lg shadow hover:shadow-lg transition-shadow overflow-hidden">
        <div className="p-6">
          <div className="flex items-center justify-between mb-4">
            <span className="px-3 py-1 text-xs font-semibold text-blue-600 bg-blue-100 rounded-full">
              {assetType}
            </span>
            <span className="text-sm text-gray-500">#{assetId}</span>
          </div>

          <h3 className="text-lg font-semibold text-gray-900 mb-2">
            {assetType} Asset
          </h3>

          <div className="space-y-2">
            <div className="flex items-center text-sm text-gray-600">
              <DollarSign className="w-4 h-4 mr-2" />
              <span>Value: ${(Number(asset[5]) / 1e18).toLocaleString()}</span>
            </div>
            <div className="flex items-center text-sm text-gray-600">
              <TrendingUp className="w-4 h-4 mr-2" />
              <span>Yield: {Number(asset[8]) / 100}%</span>
            </div>
            <div className="flex items-center text-sm text-gray-600">
              <Calendar className="w-4 h-4 mr-2" />
              <span>
                Maturity: {new Date(Number(asset[6]) * 1000).toLocaleDateString()}
              </span>
            </div>
          </div>

          <button className="mt-4 w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 transition-colors">
            View Details
          </button>
        </div>
      </div>
    </Link>
  );
}
