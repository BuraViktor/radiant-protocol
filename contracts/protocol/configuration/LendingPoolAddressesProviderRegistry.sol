// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LendingPoolAddressesProviderRegistry {
    // State variables
    mapping(address => bool) private registeredProviders;
    address[] private providers;

    // Events
    event ProviderRegistered(address indexed provider);
    event ProviderDeregistered(address indexed provider);

    // Modifier to check for zero address
    modifier nonZeroAddress(address _address) {
        require(_address != address(0), "Address cannot be zero");
        _;
    }

    // Register a provider
    function registerProvider(address _provider) external nonZeroAddress(_provider) {
        require(_provider.code.length > 0, "Address must be a contract"); // Ensure it's a contract
        require(!registeredProviders[_provider], "Provider already registered");

        registeredProviders[_provider] = true;
        providers.push(_provider);
        emit ProviderRegistered(_provider);
    }

    // Deregister a provider
    function deregisterProvider(address _provider) external nonZeroAddress(_provider) {
        require(registeredProviders[_provider], "Provider not registered");

        // Swap-and-pop technique for efficient array removal
        uint256 index = findProviderIndex(_provider);
        providers[index] = providers[providers.length - 1];
        providers.pop();
        delete registeredProviders[_provider];

        emit ProviderDeregistered(_provider);
    }

    // Find index of a provider
    function findProviderIndex(address _provider) internal view returns (uint256) {
        for (uint256 i = 0; i < providers.length; i++) {
            if (providers[i] == _provider) {
                return i;
            }
        }
        revert("Provider not found");
    }

    // Check if a provider is registered
    function isProviderRegistered(address _provider) external view returns (bool) {
        return registeredProviders[_provider];
    }

    // Get count of registered providers
    function getProvidersCount() external view returns (uint256) {
        return providers.length;
    }

    // Other functions can be added here
}