// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract OracleUpdater is AccessControl {
    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");

    struct PriceData {
        uint256 value;
        uint256 timestamp;
        uint256 confidence;
    }

    struct RiskScore {
        uint256 score;
        uint256 timestamp;
        string reason;
    }

    mapping(uint256 => PriceData) public assetPrices;
    mapping(uint256 => RiskScore) public assetRiskScores;
    mapping(string => uint256) public externalDataFeeds;

    event PriceUpdated(uint256 indexed assetId, uint256 price, uint256 confidence);
    event RiskScoreUpdated(uint256 indexed assetId, uint256 score, string reason);
    event ExternalDataUpdated(string indexed feedId, uint256 value);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ORACLE_ROLE, msg.sender);
    }

    function updateAssetPrice(
        uint256 assetId,
        uint256 price,
        uint256 confidence
    ) external onlyRole(ORACLE_ROLE) {
        require(confidence <= 100, "Invalid confidence");

        assetPrices[assetId] = PriceData({
            value: price,
            timestamp: block.timestamp,
            confidence: confidence
        });

        emit PriceUpdated(assetId, price, confidence);
    }

    function updateRiskScore(
        uint256 assetId,
        uint256 score,
        string calldata reason
    ) external onlyRole(ORACLE_ROLE) {
        require(score <= 100, "Invalid score");

        assetRiskScores[assetId] = RiskScore({
            score: score,
            timestamp: block.timestamp,
            reason: reason
        });

        emit RiskScoreUpdated(assetId, score, reason);
    }

    function updateExternalData(
        string calldata feedId,
        uint256 value
    ) external onlyRole(ORACLE_ROLE) {
        externalDataFeeds[feedId] = value;
        emit ExternalDataUpdated(feedId, value);
    }

    function batchUpdatePrices(
        uint256[] calldata assetIds,
        uint256[] calldata prices,
        uint256[] calldata confidences
    ) external onlyRole(ORACLE_ROLE) {
        require(
            assetIds.length == prices.length && 
            prices.length == confidences.length,
            "Array length mismatch"
        );

        for (uint256 i = 0; i < assetIds.length; i++) {
            require(confidences[i] <= 100, "Invalid confidence");
            
            assetPrices[assetIds[i]] = PriceData({
                value: prices[i],
                timestamp: block.timestamp,
                confidence: confidences[i]
            });

            emit PriceUpdated(assetIds[i], prices[i], confidences[i]);
        }
    }

    function getAssetPrice(uint256 assetId) 
        external 
        view 
        returns (uint256 price, uint256 timestamp, uint256 confidence) 
    {
        PriceData memory data = assetPrices[assetId];
        return (data.value, data.timestamp, data.confidence);
    }

    function getAssetRiskScore(uint256 assetId) 
        external 
        view 
        returns (uint256 score, uint256 timestamp, string memory reason) 
    {
        RiskScore memory risk = assetRiskScores[assetId];
        return (risk.score, risk.timestamp, risk.reason);
    }

    function getExternalData(string calldata feedId) 
        external 
        view 
        returns (uint256) 
    {
        return externalDataFeeds[feedId];
    }
}
