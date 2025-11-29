import express from 'express';
import AIAnalyzer from '../agents/ai-analyzer.js';

const router = express.Router();

router.post('/document', async (req, res) => {
  try {
    const { documentText } = req.body;

    if (!documentText) {
      return res.status(400).json({ error: 'Document text is required' });
    }

    const analysis = await AIAnalyzer.analyzeAssetDocument(documentText);
    
    res.json({ analysis });
  } catch (error) {
    console.error('Analysis error:', error);
    res.status(500).json({ error: error.message });
  }
});

router.post('/risk-score', async (req, res) => {
  try {
    const { assetData } = req.body;

    if (!assetData) {
      return res.status(400).json({ error: 'Asset data is required' });
    }

    const riskScore = await AIAnalyzer.calculateRiskScore(assetData);
    
    res.json({ riskScore });
  } catch (error) {
    console.error('Risk calculation error:', error);
    res.status(500).json({ error: error.message });
  }
});

router.post('/yield-prediction', async (req, res) => {
  try {
    const { assetData, marketConditions } = req.body;

    if (!assetData) {
      return res.status(400).json({ error: 'Asset data is required' });
    }

    const predictedYield = await AIAnalyzer.predictYield(assetData, marketConditions);
    
    res.json({ predictedYield });
  } catch (error) {
    console.error('Yield prediction error:', error);
    res.status(500).json({ error: error.message });
  }
});

export default router;
