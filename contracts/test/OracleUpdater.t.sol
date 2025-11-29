// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/OracleUpdater.sol";

contract OracleUpdaterTest is Test {
    OracleUpdater public oracle;
    
    address public admin;
    address public oracleWorker;
    
    uint256 public constant ASSET_ID = 1;
    
    function setUp() public {
        admin = address(this);
        oracleWorker = address(0x1);
        
        oracle = new OracleUpdater();
        oracle.grantRole(oracle.ORACLE_ROLE(), oracleWorker);
    }
    
    function testUpdateAssetPrice() public {
        vm.prank(oracleWorker);
        oracle.updateAssetPrice(ASSET_ID, 1000000, 95);
        
        (uint256 price, uint256 timestamp, uint256 confidence) = oracle.getAssetPrice(ASSET_ID);
        
        assertEq(price, 1000000);
        assertEq(confidence, 95);
        assertEq(timestamp, block.timestamp);
    }
    
    function testUpdateRiskScore() public {
        vm.prank(oracleWorker);
        oracle.updateRiskScore(ASSET_ID, 75, "Moderate risk due to market volatility");
        
        (uint256 score, uint256 timestamp, string memory reason) = oracle.getAssetRiskScore(ASSET_ID);
        
        assertEq(score, 75);
        assertEq(timestamp, block.timestamp);
        assertEq(reason, "Moderate risk due to market volatility");
    }
    
    function testUpdateExternalData() public {
        vm.prank(oracleWorker);
        oracle.updateExternalData("USD_INTEREST_RATE", 525);
        
        uint256 value = oracle.getExternalData("USD_INTEREST_RATE");
        assertEq(value, 525);
    }
    
    function testBatchUpdatePrices() public {
        uint256[] memory assetIds = new uint256[](3);
        assetIds[0] = 1;
        assetIds[1] = 2;
        assetIds[2] = 3;
        
        uint256[] memory prices = new uint256[](3);
        prices[0] = 1000000;
        prices[1] = 2000000;
        prices[2] = 3000000;
        
        uint256[] memory confidences = new uint256[](3);
        confidences[0] = 95;
        confidences[1] = 90;
        confidences[2] = 85;
        
        vm.prank(oracleWorker);
        oracle.batchUpdatePrices(assetIds, prices, confidences);
        
        (uint256 price1, , uint256 conf1) = oracle.getAssetPrice(1);
        (uint256 price2, , uint256 conf2) = oracle.getAssetPrice(2);
        (uint256 price3, , uint256 conf3) = oracle.getAssetPrice(3);
        
        assertEq(price1, 1000000);
        assertEq(conf1, 95);
        assertEq(price2, 2000000);
        assertEq(conf2, 90);
        assertEq(price3, 3000000);
        assertEq(conf3, 85);
    }
    
    function testInvalidConfidenceFails() public {
        vm.prank(oracleWorker);
        vm.expectRevert("Invalid confidence");
        oracle.updateAssetPrice(ASSET_ID, 1000000, 101);
    }
    
    function testInvalidRiskScoreFails() public {
        vm.prank(oracleWorker);
        vm.expectRevert("Invalid score");
        oracle.updateRiskScore(ASSET_ID, 101, "Too high");
    }
    
    function testBatchUpdateArrayLengthMismatchFails() public {
        uint256[] memory assetIds = new uint256[](2);
        assetIds[0] = 1;
        assetIds[1] = 2;
        
        uint256[] memory prices = new uint256[](3);
        prices[0] = 1000000;
        prices[1] = 2000000;
        prices[2] = 3000000;
        
        uint256[] memory confidences = new uint256[](2);
        confidences[0] = 95;
        confidences[1] = 90;
        
        vm.prank(oracleWorker);
        vm.expectRevert("Array length mismatch");
        oracle.batchUpdatePrices(assetIds, prices, confidences);
    }
    
    function testUnauthorizedUpdateFails() public {
        address unauthorized = address(0x999);
        
        vm.prank(unauthorized);
        vm.expectRevert();
        oracle.updateAssetPrice(ASSET_ID, 1000000, 95);
    }
    
    function testMultipleUpdatesOverwritePrevious() public {
        vm.prank(oracleWorker);
        oracle.updateAssetPrice(ASSET_ID, 1000000, 95);
        
        vm.warp(block.timestamp + 1 hours);
        
        vm.prank(oracleWorker);
        oracle.updateAssetPrice(ASSET_ID, 1100000, 97);
        
        (uint256 price, uint256 timestamp, uint256 confidence) = oracle.getAssetPrice(ASSET_ID);
        
        assertEq(price, 1100000);
        assertEq(confidence, 97);
        assertEq(timestamp, block.timestamp);
    }
}
