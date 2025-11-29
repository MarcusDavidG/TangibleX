// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "../src/KYCManager.sol";
import "../src/AssetRegistry.sol";
import "../src/OracleUpdater.sol";
import "../src/YieldVault.sol";
import "../src/RWAERC20.sol";

contract ExportABI is Script {
    function run() external pure {
        // This script is used to generate ABI files
        // Run: forge inspect ContractName abi > ../frontend/src/contracts/ContractName.json
    }
}
