// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/RWAERC20.sol";
import "../src/KYCManager.sol";

contract RWAERC20Test is Test {
    RWAERC20 public token;
    KYCManager public kycManager;
    
    address public admin;
    address public user1;
    address public user2;
    
    uint256 public constant ASSET_ID = 1;
    
    function setUp() public {
        admin = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        
        kycManager = new KYCManager();
        token = new RWAERC20("Real Estate Token", "RET", address(kycManager), ASSET_ID);
    }
    
    function testMintToKYCVerifiedUser() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash");
        kycManager.verifyKYC(user1, 365 days);
        
        token.mint(user1, 1000 ether);
        assertEq(token.balanceOf(user1), 1000 ether);
    }
    
    function testMintToNonKYCUserFails() public {
        vm.expectRevert("Recipient not KYC verified");
        token.mint(user1, 1000 ether);
    }
    
    function testTransferBetweenKYCUsers() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash1");
        kycManager.verifyKYC(user1, 365 days);
        
        vm.prank(user2);
        kycManager.submitKYC("QmTestHash2");
        kycManager.verifyKYC(user2, 365 days);
        
        token.mint(user1, 1000 ether);
        
        vm.prank(user1);
        token.transfer(user2, 500 ether);
        
        assertEq(token.balanceOf(user1), 500 ether);
        assertEq(token.balanceOf(user2), 500 ether);
    }
    
    function testTransferToNonKYCUserFails() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash1");
        kycManager.verifyKYC(user1, 365 days);
        
        token.mint(user1, 1000 ether);
        
        vm.prank(user1);
        vm.expectRevert("Recipient not KYC verified");
        token.transfer(user2, 500 ether);
    }
    
    function testBurn() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash");
        kycManager.verifyKYC(user1, 365 days);
        
        token.mint(user1, 1000 ether);
        token.burn(user1, 300 ether);
        
        assertEq(token.balanceOf(user1), 700 ether);
    }
    
    function testSetTransfersRestricted() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash1");
        kycManager.verifyKYC(user1, 365 days);
        
        token.mint(user1, 1000 ether);
        
        token.setTransfersRestricted(false);
        
        vm.prank(user1);
        token.transfer(user2, 500 ether);
        
        assertEq(token.balanceOf(user2), 500 ether);
    }
    
    function testUpdateKYCManager() public {
        KYCManager newKYCManager = new KYCManager();
        token.updateKYCManager(address(newKYCManager));
        
        assertEq(address(token.kycManager()), address(newKYCManager));
    }
    
    function testUnauthorizedMintFails() public {
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash");
        kycManager.verifyKYC(user1, 365 days);
        
        vm.prank(user1);
        vm.expectRevert();
        token.mint(user1, 1000 ether);
    }
}
