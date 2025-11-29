// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract YieldVault is AccessControl, ReentrancyGuard {
    using SafeERC20 for IERC20;

    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    struct YieldPool {
        address rwaToken;
        uint256 totalYieldDeposited;
        uint256 totalYieldClaimed;
        uint256 lastDistributionTime;
        uint256 yieldRate;
        bool active;
    }

    mapping(uint256 => YieldPool) public yieldPools;
    mapping(uint256 => mapping(address => uint256)) public userClaimedYield;

    event YieldPoolCreated(uint256 indexed assetId, address indexed rwaToken);
    event YieldDeposited(uint256 indexed assetId, uint256 amount);
    event YieldClaimed(uint256 indexed assetId, address indexed user, uint256 amount);
    event YieldRateUpdated(uint256 indexed assetId, uint256 newRate);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ORACLE_ROLE, msg.sender);
        _grantRole(MANAGER_ROLE, msg.sender);
    }

    function createYieldPool(
        uint256 assetId,
        address rwaToken,
        uint256 initialYieldRate
    ) external onlyRole(MANAGER_ROLE) {
        require(rwaToken != address(0), "Invalid token");
        require(!yieldPools[assetId].active, "Pool exists");

        yieldPools[assetId] = YieldPool({
            rwaToken: rwaToken,
            totalYieldDeposited: 0,
            totalYieldClaimed: 0,
            lastDistributionTime: block.timestamp,
            yieldRate: initialYieldRate,
            active: true
        });

        emit YieldPoolCreated(assetId, rwaToken);
    }

    function depositYield(uint256 assetId) external payable onlyRole(ORACLE_ROLE) {
        require(yieldPools[assetId].active, "Pool not active");
        require(msg.value > 0, "No yield");

        yieldPools[assetId].totalYieldDeposited += msg.value;
        yieldPools[assetId].lastDistributionTime = block.timestamp;

        emit YieldDeposited(assetId, msg.value);
    }

    function claimYield(uint256 assetId) external nonReentrant {
        YieldPool storage pool = yieldPools[assetId];
        require(pool.active, "Pool not active");

        uint256 userBalance = IERC20(pool.rwaToken).balanceOf(msg.sender);
        require(userBalance > 0, "No tokens");

        uint256 totalSupply = IERC20(pool.rwaToken).totalSupply();
        require(totalSupply > 0, "No supply");

        uint256 availableYield = pool.totalYieldDeposited - pool.totalYieldClaimed;
        uint256 userShare = (availableYield * userBalance) / totalSupply;
        uint256 claimableAmount = userShare - userClaimedYield[assetId][msg.sender];

        require(claimableAmount > 0, "No yield to claim");
        require(address(this).balance >= claimableAmount, "Insufficient vault balance");

        userClaimedYield[assetId][msg.sender] += claimableAmount;
        pool.totalYieldClaimed += claimableAmount;

        (bool success, ) = msg.sender.call{value: claimableAmount}("");
        require(success, "Transfer failed");

        emit YieldClaimed(assetId, msg.sender, claimableAmount);
    }

    function updateYieldRate(uint256 assetId, uint256 newRate) 
        external 
        onlyRole(ORACLE_ROLE) 
    {
        require(yieldPools[assetId].active, "Pool not active");
        yieldPools[assetId].yieldRate = newRate;
        emit YieldRateUpdated(assetId, newRate);
    }

    function getClaimableYield(uint256 assetId, address user) 
        external 
        view 
        returns (uint256) 
    {
        YieldPool memory pool = yieldPools[assetId];
        if (!pool.active) return 0;

        uint256 userBalance = IERC20(pool.rwaToken).balanceOf(user);
        if (userBalance == 0) return 0;

        uint256 totalSupply = IERC20(pool.rwaToken).totalSupply();
        if (totalSupply == 0) return 0;

        uint256 availableYield = pool.totalYieldDeposited - pool.totalYieldClaimed;
        uint256 userShare = (availableYield * userBalance) / totalSupply;
        
        return userShare - userClaimedYield[assetId][user];
    }

    receive() external payable {}
}
