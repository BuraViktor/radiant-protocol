// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ILendingPoolAddressesProviderRegistry.sol";

contract LendingPoolAddressesProviderRegistry is ILendingPoolAddressesProviderRegistry {
    mapping(address => bool) private providers;
    address[] private providerList;

    event ProviderAdded(address indexed provider);
    event ProviderRemoved(address indexed provider);

    constructor() {
        // Constructor logic if any
    }

    modifier validAddress(address _address) {
        require(_address != address(0), "Zero address not allowed");
        _;
    }

    // Add a provider to the registry
    function addProvider(address _provider) external validAddress(_provider) {
        require(!providers[_provider], "Provider already exists");
        providers[_provider] = true;
        providerList.push(_provider);
        emit ProviderAdded(_provider);
    }

    // Remove a provider from the registry
    function removeProvider(address _provider) external validAddress(_provider) {
        require(providers[_provider], "Provider does not exist");
        // Swap-and-pop technique for efficient removal
        for (uint256 i = 0; i < providerList.length; i++) {
            if (providerList[i] == _provider) {
                providerList[i] = providerList[providerList.length - 1];
                providerList.pop();
                break;
            }
        }
        delete providers[_provider];
        emit ProviderRemoved(_provider);
    }

    // Check if a provider exists
    function isProvider(address _provider) external view returns (bool) {
        return providers[_provider];
    }

    // Get the number of providers
    function getProviderCount() external view returns (uint256) {
        return providerList.length;
    }

    // Get provider at a specific index
    function getProviderAt(uint256 index) external view returns (address) {
        require(index < providerList.length, "Index out of bounds");
        return providerList[index];
    }

    // Get all providers
    function getAllProviders() external view returns (address[] memory) {
        return providerList;
    }
}