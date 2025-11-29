import OpenAI from 'openai';
import dotenv from 'dotenv';

dotenv.config();

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export class AIAnalyzer {
  async analyzeAssetDocument(documentText) {
    try {
      const response = await openai.chat.completions.create({
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: `You are an expert financial analyst specializing in real-world asset (RWA) tokenization. 
            Analyze asset documents and provide structured insights including risk assessment, yield predictions, 
            and valuation estimates. Return JSON format only.`
          },
          {
            role: 'user',
            content: `Analyze this asset document and provide:
1. Risk score (0-100, where 100 is highest risk)
2. Expected annual yield percentage
3. Estimated market value
4. Key risk factors
5. Investment recommendation

Document: ${documentText}`
          }
        ],
        response_format: { type: 'json_object' },
        temperature: 0.3,
      });

      return JSON.parse(response.choices[0].message.content);
    } catch (error) {
      console.error('AI Analysis Error:', error);
      return this.getMockAnalysis();
    }
  }

  async calculateRiskScore(assetData) {
    const factors = {
      assetType: this.getAssetTypeRisk(assetData.assetType),
      maturity: this.getMaturityRisk(assetData.maturityDate),
      value: this.getValueRisk(assetData.totalValue),
      issuer: this.getIssuerRisk(assetData.issuer),
    };

    const weights = { assetType: 0.3, maturity: 0.2, value: 0.3, issuer: 0.2 };
    
    const riskScore = Object.entries(factors).reduce(
      (total, [key, value]) => total + value * weights[key],
      0
    );

    return Math.round(riskScore);
  }

  async predictYield(assetData, marketConditions = {}) {
    const baseYield = assetData.expectedYield || 5.0;
    const riskPremium = (await this.calculateRiskScore(assetData)) / 20;
    const marketAdjustment = marketConditions.interestRate || 0;

    return (baseYield + riskPremium + marketAdjustment).toFixed(2);
  }

  getAssetTypeRisk(type) {
    const riskMap = {
      0: 30, // RealEstate
      1: 50, // Invoice
      2: 25, // Bond
      3: 60, // Loan
      4: 40, // Other
    };
    return riskMap[type] || 50;
  }

  getMaturityRisk(maturityTimestamp) {
    const monthsToMaturity = (maturityTimestamp - Date.now()) / (1000 * 60 * 60 * 24 * 30);
    if (monthsToMaturity < 3) return 60;
    if (monthsToMaturity < 12) return 40;
    if (monthsToMaturity < 36) return 30;
    return 20;
  }

  getValueRisk(value) {
    if (value < 100000) return 50;
    if (value < 1000000) return 30;
    return 20;
  }

  getIssuerRisk(issuer) {
    return 30;
  }

  getMockAnalysis() {
    return {
      riskScore: 35,
      expectedYield: 6.5,
      estimatedValue: 500000,
      riskFactors: [
        'Market volatility',
        'Liquidity concerns',
        'Regulatory compliance'
      ],
      recommendation: 'Moderate risk investment suitable for diversified portfolios'
    };
  }
}

export default new AIAnalyzer();
