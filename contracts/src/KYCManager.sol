// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract KYCManager is AccessControl {
    bytes32 public constant KYC_ADMIN_ROLE = keccak256("KYC_ADMIN_ROLE");
    bytes32 public constant KYC_VERIFIED_ROLE = keccak256("KYC_VERIFIED_ROLE");

    enum KYCStatus { None, Pending, Verified, Rejected }

    struct KYCData {
        KYCStatus status;
        uint256 verifiedAt;
        uint256 expiresAt;
        string documentHash;
    }

    mapping(address => KYCData) public kycData;

    event KYCSubmitted(address indexed user, string documentHash);
    event KYCVerified(address indexed user, uint256 expiresAt);
    event KYCRejected(address indexed user, string reason);
    event KYCRevoked(address indexed user);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(KYC_ADMIN_ROLE, msg.sender);
    }

    function submitKYC(string calldata documentHash) external {
        require(kycData[msg.sender].status != KYCStatus.Verified, "Already verified");
        
        kycData[msg.sender] = KYCData({
            status: KYCStatus.Pending,
            verifiedAt: 0,
            expiresAt: 0,
            documentHash: documentHash
        });

        emit KYCSubmitted(msg.sender, documentHash);
    }

    function verifyKYC(address user, uint256 validityPeriod) external onlyRole(KYC_ADMIN_ROLE) {
        require(kycData[user].status == KYCStatus.Pending, "Invalid status");
        
        uint256 expiresAt = block.timestamp + validityPeriod;
        
        kycData[user].status = KYCStatus.Verified;
        kycData[user].verifiedAt = block.timestamp;
        kycData[user].expiresAt = expiresAt;

        _grantRole(KYC_VERIFIED_ROLE, user);

        emit KYCVerified(user, expiresAt);
    }

    function rejectKYC(address user, string calldata reason) external onlyRole(KYC_ADMIN_ROLE) {
        require(kycData[user].status == KYCStatus.Pending, "Invalid status");
        
        kycData[user].status = KYCStatus.Rejected;

        emit KYCRejected(user, reason);
    }

    function revokeKYC(address user) external onlyRole(KYC_ADMIN_ROLE) {
        require(kycData[user].status == KYCStatus.Verified, "Not verified");
        
        kycData[user].status = KYCStatus.None;
        _revokeRole(KYC_VERIFIED_ROLE, user);

        emit KYCRevoked(user);
    }

    function isKYCVerified(address user) external view returns (bool) {
        KYCData memory data = kycData[user];
        return data.status == KYCStatus.Verified && 
               (data.expiresAt == 0 || block.timestamp < data.expiresAt);
    }

    function getKYCStatus(address user) external view returns (KYCStatus, uint256, uint256) {
        KYCData memory data = kycData[user];
        return (data.status, data.verifiedAt, data.expiresAt);
    }
}
