// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/YieldVault.sol";
import "../src/RWAERC20.sol";
import "../src/KYCManager.sol";

contract YieldVaultTest is Test {
    YieldVault public vault;
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
        vault = new YieldVault();
        
        vm.prank(user1);
        kycManager.submitKYC("QmTestHash1");
        kycManager.verifyKYC(user1, 365 days);
        
        vm.prank(user2);
        kycManager.submitKYC("QmTestHash2");
        kycManager.verifyKYC(user2, 365 days);
    }
    
    function testCreateYieldPool() public {
        vault.createYieldPool(ASSET_ID, address(token), 500);
        
        (address rwaToken, , , , uint256 yieldRate, bool active) = vault.yieldPools(ASSET_ID);
        assertEq(rwaToken, address(token));
        assertEq(yieldRate, 500);
        assertTrue(active);
    }
    
    function testDepositYield() public {
        vault.createYieldPool(ASSET_ID, address(token), 500);
        
        vault.depositYield{value: 10 ether}(ASSET_ID);
        
        (, uint256 totalYieldDeposited, , , , ) = vault.yieldPools(ASSET_ID);
        assertEq(totalYieldDeposited, 10 ether);
    }
    
    function testClaimYield() public {
        vault.createYieldPool(ASSET_ID, address(token), 500);
        
        token.mint(user1, 1000 ether);
        token.mint(user2, 1000 ether);
        
        vault.depositYield{value: 10 ether}(ASSET_ID);
        
        uint256 balanceBefore = user1.balance;
        
        vm.prank(user1);
        vault.claimYield(ASSET_ID);
        
        uint256 balanceAfter = user1.balance;
        assertGt(balanceAfter, balanceBefore);
    }
    
    function testClaimYieldProportional() public {
        vault.createYieldPool(ASSET_ID, address(token), 500);
        
        token.mint(user1, 2000 ether);
        token.mint(user2, 1000 ether);
        
        vault.depositYield{value: 9 ether}(ASSET_ID);
        
        vm.prank(user1);
        vault.claimYield(ASSET_ID);
        
        vm.prank(user2);
        vault.claimYield(ASSET_ID);
        
        assertGt(user1.balance, user2.balance);
    }
    
    function testUpdateYieldRate() public {
        vault.createYieldPool(ASSET_ID, address(token), 500);
        
        vault.updateYieldRate(ASSET_ID, 750);
        
        (, , , , uint256 yieldRate, ) = vault.yieldPools(ASSET_ID);
        assertEq(yieldRate, 750);
    }
    
    function testGetClaimableYield() public {
        vault.createYieldPool(ASSET_ID, address(token), 500);
        
        token.mint(user1, 1000 ether);
        vault.depositYield{value: 10 ether}(ASSET_ID);
        
        uint256 claimable = vault.getClaimableYield(ASSET_ID, user1);
        assertEq(claimable, 10 ether);
    }
    
    function testClaimWithNoTokensFails() public {
        vault.createYieldPool(ASSET_ID, address(token), 500);
        vault.depositYield{value: 10 ether}(ASSET_ID);
        
        vm.prank(user1);
        vm.expectRevert("No tokens");
        vault.claimYield(ASSET_ID);
    }
    
    function testCreateDuplicatePoolFails() public {
        vault.createYieldPool(ASSET_ID, address(token), 500);
        
        vm.expectRevert("Pool exists");
        vault.createYieldPool(ASSET_ID, address(token), 500);
    }
    
    receive() external payable {}
}
