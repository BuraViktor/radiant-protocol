// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LendingPoolAddressesProviderRegistry {
    address[] private providers;
    mapping(address => bool) private activeProviders;
    mapping(address => uint256) private providerIndex;

    event ProviderAdded(address indexed provider);
    event ProviderRemoved(address indexed provider);

    modifier onlyActiveProvider(address provider) {
        require(activeProviders[provider], "Provider is not active");
        _;
    }

    function addProvider(address provider) external {
        require(provider != address(0), "Invalid address: zero address");
        require(!activeProviders[provider], "Provider already exists");

        activeProviders[provider] = true;
        providers.push(provider);
        providerIndex[provider] = providers.length - 1;

        emit ProviderAdded(provider);
    }

    function removeProvider(address provider) external onlyActiveProvider(provider) {
        // Swap and pop method for efficient removal
        uint256 index = providerIndex[provider];
        uint256 lastIndex = providers.length - 1;

        if (index != lastIndex) {
            providers[index] = providers[lastIndex]; // Move the last provider to the removed spot
            providerIndex[providers[lastIndex]] = index; // Update the moved provider's index
        }

        providers.pop(); // Remove the last element
        delete activeProviders[provider];
        delete providerIndex[provider];

        emit ProviderRemoved(provider);
    }

    function getAddressesProvidersList() external view returns (address[] memory) {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < providers.length; i++) {
            if (activeProviders[providers[i]]) {
                activeCount++;
            }
        }

        address[] memory activeProvidersList = new address[](activeCount);
        uint256 j = 0;
        for (uint256 i = 0; i < providers.length; i++) {
            if (activeProviders[providers[i]]) {
                activeProvidersList[j] = providers[i];
                j++;
            }
        }

        return activeProvidersList;
    }
}