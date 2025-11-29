import express from 'express';
import multer from 'multer';

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

router.post('/submit', upload.single('document'), async (req, res) => {
  try {
    const { address } = req.body;
    const document = req.file;

    if (!address || !document) {
      return res.status(400).json({ error: 'Address and document are required' });
    }

    const mockDocumentHash = `Qm${Math.random().toString(36).substring(7)}`;

    res.json({
      success: true,
      documentHash: mockDocumentHash,
      message: 'KYC document submitted successfully. Awaiting verification.'
    });
  } catch (error) {
    console.error('KYC submission error:', error);
    res.status(500).json({ error: error.message });
  }
});

router.get('/status/:address', async (req, res) => {
  try {
    const { address } = req.params;

    const mockStatus = {
      status: 'pending',
      submittedAt: Date.now(),
      documentHash: 'QmMockHash123'
    };

    res.json({ status: mockStatus });
  } catch (error) {
    console.error('KYC status error:', error);
    res.status(500).json({ error: error.message });
  }
});

export default router;
