import { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import axios from 'axios';
import { Shield, TrendingUp, Calendar, DollarSign, User } from 'lucide-react';

export default function AssetDetail() {
  const { assetId } = useParams();
  const [asset, setAsset] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchAssetDetail();
  }, [assetId]);

  const fetchAssetDetail = async () => {
    try {
      const response = await axios.get(`/api/assets/${assetId}`);
      setAsset(response.data.asset);
    } catch (error) {
      console.error('Error fetching asset:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="text-center py-12">Loading asset details...</div>;
  }

  if (!asset) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500">Asset not found</p>
      </div>
    );
  }

  const assetTypes = ['Real Estate', 'Invoice', 'Bond', 'Loan', 'Other'];
  const assetType = assetTypes[asset[1]] || 'Unknown';

  return (
    <div className="px-4 sm:px-0">
      <div className="bg-white shadow rounded-lg overflow-hidden">
        <div className="p-6 border-b border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">{assetType} Asset #{assetId}</h1>
              <p className="mt-1 text-sm text-gray-500">IPFS: {asset[0]}</p>
            </div>
            <span className="px-4 py-2 text-sm font-semibold text-blue-600 bg-blue-100 rounded-full">
              {assetType}
            </span>
          </div>
        </div>

        <div className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
            <InfoCard icon={<DollarSign />} label="Total Value" value={`$${(Number(asset[5]) / 1e18).toLocaleString()}`} />
            <InfoCard icon={<TrendingUp />} label="Expected Yield" value={`${Number(asset[8]) / 100}%`} />
            <InfoCard icon={<Calendar />} label="Maturity Date" value={new Date(Number(asset[6]) * 1000).toLocaleDateString()} />
            <InfoCard icon={<Shield />} label="Risk Score" value="Medium" />
          </div>

          <div className="mb-8">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">Asset Information</h2>
            <dl className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <InfoRow label="Issuer" value={asset[3]} />
              <InfoRow label="Token Address" value={asset[4] || 'Not linked'} />
              <InfoRow label="Created At" value={new Date(Number(asset[7]) * 1000).toLocaleDateString()} />
              <InfoRow label="Status" value="Active" />
            </dl>
          </div>

          <div className="flex gap-4">
            <button className="flex-1 bg-blue-600 text-white py-3 px-6 rounded-md hover:bg-blue-700 transition-colors font-semibold">
              Invest Now
            </button>
            <button className="flex-1 bg-gray-200 text-gray-700 py-3 px-6 rounded-md hover:bg-gray-300 transition-colors font-semibold">
              Download Prospectus
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

function InfoCard({ icon, label, value }) {
  return (
    <div className="flex items-center p-4 bg-gray-50 rounded-lg">
      <div className="flex-shrink-0 text-blue-600">{icon}</div>
      <div className="ml-4">
        <p className="text-sm text-gray-500">{label}</p>
        <p className="text-lg font-semibold text-gray-900">{value}</p>
      </div>
    </div>
  );
}

function InfoRow({ label, value }) {
  return (
    <div>
      <dt className="text-sm font-medium text-gray-500">{label}</dt>
      <dd className="mt-1 text-sm text-gray-900 break-all">{value}</dd>
    </div>
  );
}
