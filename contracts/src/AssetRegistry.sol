// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AssetRegistry is AccessControl {
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");

    enum AssetType { RealEstate, Invoice, Bond, Loan, Other }
    enum AssetStatus { Pending, Active, Matured, Defaulted }

    struct Asset {
        string ipfsHash;
        AssetType assetType;
        AssetStatus status;
        address issuer;
        address tokenAddress;
        uint256 totalValue;
        uint256 maturityDate;
        uint256 createdAt;
        uint256 expectedYield;
        string metadata;
    }

    uint256 public assetCount;
    mapping(uint256 => Asset) public assets;
    mapping(address => uint256[]) public issuerAssets;

    event AssetRegistered(
        uint256 indexed assetId,
        address indexed issuer,
        AssetType assetType,
        uint256 totalValue
    );
    event AssetStatusUpdated(uint256 indexed assetId, AssetStatus newStatus);
    event AssetTokenLinked(uint256 indexed assetId, address tokenAddress);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ISSUER_ROLE, msg.sender);
    }

    function registerAsset(
        string calldata ipfsHash,
        AssetType assetType,
        uint256 totalValue,
        uint256 maturityDate,
        uint256 expectedYield,
        string calldata metadata
    ) external onlyRole(ISSUER_ROLE) returns (uint256) {
        require(totalValue > 0, "Invalid value");
        require(maturityDate > block.timestamp, "Invalid maturity");

        uint256 assetId = assetCount++;

        assets[assetId] = Asset({
            ipfsHash: ipfsHash,
            assetType: assetType,
            status: AssetStatus.Pending,
            issuer: msg.sender,
            tokenAddress: address(0),
            totalValue: totalValue,
            maturityDate: maturityDate,
            createdAt: block.timestamp,
            expectedYield: expectedYield,
            metadata: metadata
        });

        issuerAssets[msg.sender].push(assetId);

        emit AssetRegistered(assetId, msg.sender, assetType, totalValue);

        return assetId;
    }

    function linkToken(uint256 assetId, address tokenAddress) 
        external 
        onlyRole(DEFAULT_ADMIN_ROLE) 
    {
        require(assetId < assetCount, "Invalid asset");
        require(tokenAddress != address(0), "Invalid token");
        require(assets[assetId].tokenAddress == address(0), "Already linked");

        assets[assetId].tokenAddress = tokenAddress;

        emit AssetTokenLinked(assetId, tokenAddress);
    }

    function updateAssetStatus(uint256 assetId, AssetStatus newStatus) 
        external 
    {
        require(assetId < assetCount, "Invalid asset");
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || 
            hasRole(AUDITOR_ROLE, msg.sender),
            "Unauthorized"
        );

        assets[assetId].status = newStatus;

        emit AssetStatusUpdated(assetId, newStatus);
    }

    function getAsset(uint256 assetId) 
        external 
        view 
        returns (Asset memory) 
    {
        require(assetId < assetCount, "Invalid asset");
        return assets[assetId];
    }

    function getIssuerAssets(address issuer) 
        external 
        view 
        returns (uint256[] memory) 
    {
        return issuerAssets[issuer];
    }

    function getActiveAssets() external view returns (uint256[] memory) {
        uint256 activeCount = 0;
        
        for (uint256 i = 0; i < assetCount; i++) {
            if (assets[i].status == AssetStatus.Active) {
                activeCount++;
            }
        }

        uint256[] memory activeAssets = new uint256[](activeCount);
        uint256 index = 0;

        for (uint256 i = 0; i < assetCount; i++) {
            if (assets[i].status == AssetStatus.Active) {
                activeAssets[index++] = i;
            }
        }

        return activeAssets;
    }
}
