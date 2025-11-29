// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./KYCManager.sol";

contract RWAERC20 is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    KYCManager public kycManager;
    uint256 public assetId;
    bool public transfersRestricted;

    event TransfersRestrictionUpdated(bool restricted);
    event KYCManagerUpdated(address indexed newKYCManager);

    constructor(
        string memory name,
        string memory symbol,
        address _kycManager,
        uint256 _assetId
    ) ERC20(name, symbol) {
        require(_kycManager != address(0), "Invalid KYC manager");
        
        kycManager = KYCManager(_kycManager);
        assetId = _assetId;
        transfersRestricted = true;

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        require(kycManager.isKYCVerified(to), "Recipient not KYC verified");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyRole(BURNER_ROLE) {
        _burn(from, amount);
    }

    function setTransfersRestricted(bool restricted) external onlyRole(DEFAULT_ADMIN_ROLE) {
        transfersRestricted = restricted;
        emit TransfersRestrictionUpdated(restricted);
    }

    function updateKYCManager(address newKYCManager) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(newKYCManager != address(0), "Invalid address");
        kycManager = KYCManager(newKYCManager);
        emit KYCManagerUpdated(newKYCManager);
    }

    function _update(address from, address to, uint256 amount) internal virtual override {
        if (transfersRestricted) {
            if (from != address(0) && to != address(0)) {
                require(kycManager.isKYCVerified(from), "Sender not KYC verified");
                require(kycManager.isKYCVerified(to), "Recipient not KYC verified");
            }
        }
        
        super._update(from, to, amount);
    }
}
