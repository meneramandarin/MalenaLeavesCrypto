// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@ensdomains/ens-contracts/contracts/registry/ENS.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/Resolver.sol";
import "@chainlink/contracts/src/v0.8/automation/interfaces/KeeperCompatibleInterface.sol";

contract MalenaLeavesCrypto is ERC20Upgradeable, KeeperCompatibleInterface, PausableUpgradeable, OwnableUpgradeable {
    ENS private ensRegistry;
    bytes32 private ensNameHash;
    bool public isActive = true;
    uint256 public constant MAX_SUPPLY = 69;

    constructor() {}

    function initialize(string memory name, string memory symbol, bytes32 _ensNameHash, ENS _ensRegistry) public initializer {
        __ERC20_init("MalenaLeavesCrypto", "MLC");
        __Pausable_init();
        __Ownable_init();
        ensNameHash = _ensNameHash;
        ensRegistry = _ensRegistry;
    }

    function validateOwnership() public view returns (bool) {
        address resolvedAddress = Resolver(ensRegistry.resolver(ensNameHash)).addr(ensNameHash);
        return resolvedAddress == address(this);
    }

    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory) {
        upkeepNeeded = isDomainExpired();
    }

    function performUpkeep(bytes calldata) external override {
        if (isDomainExpired()) {
            _pause();
            isActive = false;
        }
    }

    function isDomainExpired() internal view returns (bool) {
        address resolvedAddress = Resolver(ensRegistry.resolver(ensNameHash)).addr(ensNameHash);
        return resolvedAddress != address(0x0DC825282d60cEB87c87A58AB1B1d47384ae9Aa5);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(isActive, "Malena has left crypto and token is inactive");
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(isActive, "Malena has left crypto and token is inactive");
        return super.transferFrom(sender, recipient, amount);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(isActive, "Minting is disabled. Malena has left crypto");
        require(totalSupply() + amount <= MAX_SUPPLY, "Sorry you're too late");
        _mint(to, amount);
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        require(!isDomainExpired(), "Malena has left crypto");
        return super.approve(spender, amount);
    }
}