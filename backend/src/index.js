import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import assetsRoutes from './api/assets.js';
import analysisRoutes from './api/analysis.js';
import kycRoutes from './api/kyc.js';
import yieldRoutes from './api/yield.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: Date.now() });
});

app.use('/api/assets', assetsRoutes);
app.use('/api/analysis', analysisRoutes);
app.use('/api/kyc', kycRoutes);
app.use('/api/yield', yieldRoutes);

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error', message: err.message });
});

app.listen(PORT, () => {
  console.log(`🚀 TangibleX Backend running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
});
