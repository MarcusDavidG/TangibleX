import { useState } from 'react';
import { useAccount } from 'wagmi';
import { Upload, CheckCircle, XCircle } from 'lucide-react';
import axios from 'axios';

export default function KYCFlow() {
  const { address, isConnected } = useAccount();
  const [file, setFile] = useState(null);
  const [status, setStatus] = useState('idle');
  const [message, setMessage] = useState('');

  const handleFileChange = (e) => {
    setFile(e.target.files[0]);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!file || !address) {
      setMessage('Please connect wallet and select a file');
      return;
    }

    setStatus('loading');
    
    try {
      const formData = new FormData();
      formData.append('document', file);
      formData.append('address', address);

      const response = await axios.post('/api/kyc/submit', formData);
      
      setStatus('success');
      setMessage('KYC document submitted successfully! Awaiting verification.');
    } catch (error) {
      setStatus('error');
      setMessage('Failed to submit KYC document. Please try again.');
    }
  };

  if (!isConnected) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500">Please connect your wallet to submit KYC</p>
      </div>
    );
  }

  return (
    <div className="px-4 sm:px-0 max-w-2xl mx-auto">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">KYC Verification</h1>
        <p className="mt-2 text-sm text-gray-700">
          Complete your KYC to access all platform features
        </p>
      </div>

      <div className="bg-white shadow rounded-lg p-6">
        <form onSubmit={handleSubmit}>
          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Upload Identity Document
            </label>
            <div className="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
              <div className="space-y-1 text-center">
                <Upload className="mx-auto h-12 w-12 text-gray-400" />
                <div className="flex text-sm text-gray-600">
                  <label className="relative cursor-pointer bg-white rounded-md font-medium text-blue-600 hover:text-blue-500">
                    <span>Upload a file</span>
                    <input
                      type="file"
                      className="sr-only"
                      onChange={handleFileChange}
                      accept=".pdf,.jpg,.png"
                    />
                  </label>
                  <p className="pl-1">or drag and drop</p>
                </div>
                <p className="text-xs text-gray-500">PDF, PNG, JPG up to 10MB</p>
              </div>
            </div>
            {file && (
              <p className="mt-2 text-sm text-gray-600">
                Selected: {file.name}
              </p>
            )}
          </div>

          <button
            type="submit"
            disabled={!file || status === 'loading'}
            className="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed"
          >
            {status === 'loading' ? 'Submitting...' : 'Submit KYC'}
          </button>
        </form>

        {message && (
          <div className={`mt-4 p-4 rounded-md ${status === 'success' ? 'bg-green-50' : 'bg-red-50'}`}>
            <div className="flex">
              {status === 'success' ? (
                <CheckCircle className="h-5 w-5 text-green-400" />
              ) : (
                <XCircle className="h-5 w-5 text-red-400" />
              )}
              <p className={`ml-3 text-sm ${status === 'success' ? 'text-green-800' : 'text-red-800'}`}>
                {message}
              </p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
