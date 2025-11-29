// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/KYCManager.sol";

contract KYCManagerTest is Test {
    KYCManager public kycManager;
    address public admin;
    address public user1;
    address public user2;

    function setUp() public {
        admin = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        kycManager = new KYCManager();
    }

    function testSubmitKYC() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash123");
        
        (KYCManager.KYCStatus status, , ) = kycManager.getKYCStatus(user1);
        assertEq(uint(status), uint(KYCManager.KYCStatus.Pending));
    }

    function testVerifyKYC() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash123");
        
        kycManager.verifyKYC(user1, 365 days);
        
        assertTrue(kycManager.isKYCVerified(user1));
    }

    function testRejectKYC() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash123");
        
        kycManager.rejectKYC(user1, "Invalid documents");
        
        (KYCManager.KYCStatus status, , ) = kycManager.getKYCStatus(user1);
        assertEq(uint(status), uint(KYCManager.KYCStatus.Rejected));
    }

    function testRevokeKYC() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash123");
        
        kycManager.verifyKYC(user1, 365 days);
        assertTrue(kycManager.isKYCVerified(user1));
        
        kycManager.revokeKYC(user1);
        assertFalse(kycManager.isKYCVerified(user1));
    }

    function testKYCExpiration() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash123");
        
        kycManager.verifyKYC(user1, 1 days);
        assertTrue(kycManager.isKYCVerified(user1));
        
        vm.warp(block.timestamp + 2 days);
        assertFalse(kycManager.isKYCVerified(user1));
    }
}
