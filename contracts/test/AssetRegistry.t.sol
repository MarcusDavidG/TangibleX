// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/AssetRegistry.sol";

contract AssetRegistryTest is Test {
    AssetRegistry public registry;
    address public issuer;

    function setUp() public {
        registry = new AssetRegistry();
        issuer = address(this);
    }

    function testRegisterAsset() public {
        uint256 assetId = registry.registerAsset(
            "QmAssetHash",
            AssetRegistry.AssetType.RealEstate,
            1000000 ether,
            block.timestamp + 365 days,
            5000,
            "metadata"
        );
        
        assertEq(assetId, 0);
        AssetRegistry.Asset memory asset = registry.getAsset(0);
        assertEq(asset.totalValue, 1000000 ether);
    }

    function testLinkToken() public {
        uint256 assetId = registry.registerAsset(
            "QmAssetHash",
            AssetRegistry.AssetType.Bond,
            500000 ether,
            block.timestamp + 180 days,
            4000,
            "metadata"
        );
        
        address tokenAddr = address(0x123);
        registry.linkToken(assetId, tokenAddr);
        
        AssetRegistry.Asset memory asset = registry.getAsset(assetId);
        assertEq(asset.tokenAddress, tokenAddr);
    }

    function testUpdateAssetStatus() public {
        uint256 assetId = registry.registerAsset(
            "QmAssetHash",
            AssetRegistry.AssetType.Invoice,
            100000 ether,
            block.timestamp + 90 days,
            3000,
            "metadata"
        );
        
        registry.updateAssetStatus(assetId, AssetRegistry.AssetStatus.Active);
        
        AssetRegistry.Asset memory asset = registry.getAsset(assetId);
        assertEq(uint(asset.status), uint(AssetRegistry.AssetStatus.Active));
    }

    function testGetActiveAssets() public {
        registry.registerAsset("Hash1", AssetRegistry.AssetType.RealEstate, 1000 ether, block.timestamp + 365 days, 5000, "meta1");
        registry.registerAsset("Hash2", AssetRegistry.AssetType.Bond, 2000 ether, block.timestamp + 180 days, 4000, "meta2");
        
        registry.updateAssetStatus(0, AssetRegistry.AssetStatus.Active);
        registry.updateAssetStatus(1, AssetRegistry.AssetStatus.Active);
        
        uint256[] memory activeAssets = registry.getActiveAssets();
        assertEq(activeAssets.length, 2);
    }
}
