// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "../src/KYCManager.sol";
import "../src/AssetRegistry.sol";
import "../src/OracleUpdater.sol";
import "../src/YieldVault.sol";
import "../src/RWAERC20.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        KYCManager kycManager = new KYCManager();
        console.log("KYCManager deployed at:", address(kycManager));

        AssetRegistry assetRegistry = new AssetRegistry();
        console.log("AssetRegistry deployed at:", address(assetRegistry));

        OracleUpdater oracleUpdater = new OracleUpdater();
        console.log("OracleUpdater deployed at:", address(oracleUpdater));

        YieldVault yieldVault = new YieldVault();
        console.log("YieldVault deployed at:", address(yieldVault));

        vm.stopBroadcast();

        console.log("\n=== Deployment Complete ===");
        console.log("Save these addresses to your .env file:");
        console.log("KYC_MANAGER_ADDRESS=", address(kycManager));
        console.log("ASSET_REGISTRY_ADDRESS=", address(assetRegistry));
        console.log("ORACLE_UPDATER_ADDRESS=", address(oracleUpdater));
        console.log("YIELD_VAULT_ADDRESS=", address(yieldVault));
    }
}
