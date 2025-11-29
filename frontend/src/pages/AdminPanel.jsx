import { useState } from 'react';
import { useAccount } from 'wagmi';
import { Settings, Users, FileText, TrendingUp } from 'lucide-react';

export default function AdminPanel() {
  const { address, isConnected } = useAccount();
  const [activeTab, setActiveTab] = useState('overview');

  if (!isConnected) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500">Please connect your wallet to access admin panel</p>
      </div>
    );
  }

  return (
    <div className="px-4 sm:px-0">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Admin Panel</h1>
        <p className="mt-2 text-sm text-gray-700">
          Manage assets, users, and system settings
        </p>
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="border-b border-gray-200">
          <nav className="flex -mb-px">
            <TabButton
              active={activeTab === 'overview'}
              onClick={() => setActiveTab('overview')}
              icon={<TrendingUp className="w-5 h-5" />}
              label="Overview"
            />
            <TabButton
              active={activeTab === 'assets'}
              onClick={() => setActiveTab('assets')}
              icon={<FileText className="w-5 h-5" />}
              label="Assets"
            />
            <TabButton
              active={activeTab === 'users'}
              onClick={() => setActiveTab('users')}
              icon={<Users className="w-5 h-5" />}
              label="Users"
            />
            <TabButton
              active={activeTab === 'settings'}
              onClick={() => setActiveTab('settings')}
              icon={<Settings className="w-5 h-5" />}
              label="Settings"
            />
          </nav>
        </div>

        <div className="p-6">
          {activeTab === 'overview' && <OverviewTab />}
          {activeTab === 'assets' && <AssetsTab />}
          {activeTab === 'users' && <UsersTab />}
          {activeTab === 'settings' && <SettingsTab />}
        </div>
      </div>
    </div>
  );
}

function TabButton({ active, onClick, icon, label }) {
  return (
    <button
      onClick={onClick}
      className={`flex items-center px-6 py-3 border-b-2 font-medium text-sm ${
        active
          ? 'border-blue-500 text-blue-600'
          : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
      }`}
    >
      {icon}
      <span className="ml-2">{label}</span>
    </button>
  );
}

function OverviewTab() {
  return (
    <div>
      <h2 className="text-xl font-semibold mb-4">System Overview</h2>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <StatCard label="Total Assets" value="0" />
        <StatCard label="Total Users" value="0" />
        <StatCard label="Pending KYC" value="0" />
      </div>
    </div>
  );
}

function AssetsTab() {
  return (
    <div>
      <h2 className="text-xl font-semibold mb-4">Asset Management</h2>
      <p className="text-gray-500">No assets to manage yet.</p>
    </div>
  );
}

function UsersTab() {
  return (
    <div>
      <h2 className="text-xl font-semibold mb-4">User Management</h2>
      <p className="text-gray-500">No users to manage yet.</p>
    </div>
  );
}

function SettingsTab() {
  return (
    <div>
      <h2 className="text-xl font-semibold mb-4">System Settings</h2>
      <p className="text-gray-500">Configure system settings here.</p>
    </div>
  );
}

function StatCard({ label, value }) {
  return (
    <div className="bg-gray-50 p-4 rounded-lg">
      <p className="text-sm text-gray-500">{label}</p>
      <p className="text-2xl font-semibold text-gray-900">{value}</p>
    </div>
  );
}
