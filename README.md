# DePo (Decentralized Price Oracle) Aggregator

## Overview
The **DePo Aggregator** is a decentralized price oracle smart contract designed to aggregate and validate price data from multiple trusted providers. It ensures price accuracy and reliability by enforcing strict validation rules, including minimum provider requirements and deviation limits. The contract allows authorized providers to submit price updates, which are then aggregated to determine a reliable median price.

## Features
- **Decentralized Price Aggregation**: Collects price data from multiple trusted providers.
- **Validation Rules**: Ensures data integrity with deviation limits and minimum provider requirements.
- **Admin Controls**: Allows contract owner to add or remove price providers.
- **Historical Price Retrieval**: Supports fetching past price data by block height.
- **Security Mechanisms**: Prevents unauthorized access and stale price retrieval.

## Constants
- **PRICE_PRECISION**: `100000000` (8 decimal places)
- **MAX_PRICE_AGE**: `900` (15 minutes in blocks)
- **MIN_PRICE_PROVIDERS**: `3` (Minimum required providers)
- **MAX_PRICE_PROVIDERS**: `10` (Maximum allowed providers)
- **MAX_PRICE_DEVIATION**: `200` (20% deviation from median price)
- **MIN_VALID_PRICE**: `100000` (Minimum acceptable price)
- **MAX_VALID_PRICE**: `1000000000` (Maximum acceptable price)

## Data Variables
- **current-price**: Stores the most recent valid median price.
- **last-update-block**: Stores the block height of the last successful price update.
- **active-providers**: Tracks the number of active price providers.

## Maps
- **price-providers**: Maps provider addresses to their authorization status.
- **provider-prices**: Stores the latest submitted price from each provider.
- **provider-last-update**: Tracks the last update block for each provider.
- **active-provider-list**: Stores a list of active providers.
- **historical-prices**: Maps block heights to past price records.

## Public Functions
### **Adding and Removing Providers**
#### `add-price-provider (provider principal) -> (ok true | ERR_NOT_AUTHORIZED)`
- Allows the contract owner to add a new price provider.

#### `remove-price-provider (provider principal) -> (ok true | ERR_NOT_AUTHORIZED)`
- Allows the contract owner to remove an existing price provider.

### **Submitting and Retrieving Prices**
#### `submit-price (price uint) -> (ok median | ERR_NOT_AUTHORIZED | ERR_PRICE_TOO_LOW | ERR_PRICE_TOO_HIGH | ERR_INSUFFICIENT_PROVIDERS)`
- Allows authorized providers to submit a price.
- Ensures price validity and calculates the median price.

#### `get-current-price () -> (ok current-price | ERR_STALE_PRICE)`
- Returns the most recent valid median price.
- Throws an error if the price is stale.

#### `get-historical-price (block uint) -> (ok {price, block} | ERR_INVALID_BLOCK)`
- Retrieves the price for a specific past block.

### **Provider Management & Status**
#### `get-price-provider-count () -> (ok active-providers)`
- Returns the number of active providers.

#### `get-provider-status (provider principal) -> (ok true | none)`
- Checks whether a given provider is authorized.

#### `get-last-update-block () -> (ok last-update-block)`
- Returns the block height of the last valid price update.

## Error Handling
- `ERR_NOT_AUTHORIZED (u100)`: Action restricted to the contract owner or authorized providers.
- `ERR_STALE_PRICE (u101)`: Price data is too old to be considered valid.
- `ERR_INSUFFICIENT_PROVIDERS (u102)`: Not enough providers have submitted prices.
- `ERR_PRICE_TOO_LOW (u103)`: Submitted price is below the acceptable range.
- `ERR_PRICE_TOO_HIGH (u104)`: Submitted price exceeds the acceptable range.
- `ERR_PRICE_DEVIATION (u105)`: Submitted price deviates too much from the median.
- `ERR_ZERO_PRICE (u106)`: Price cannot be zero.
- `ERR_INVALID_BLOCK (u107)`: Requested block height is invalid.
- `ERR_PROVIDER_EXISTS (u108)`: Provider already exists in the system.

## Security Considerations
- Only the contract owner can add or remove price providers.
- Providers must submit prices within the allowed range.
- The contract prevents single-provider price manipulation by enforcing a minimum provider count.
- Prices older than 15 minutes are rejected to prevent stale data usage.

## Usage Scenarios
- **Decentralized Exchanges (DEXs)**: Ensuring fair asset pricing.
- **Lending Platforms**: Providing accurate collateral valuations.
- **Stablecoins**: Maintaining peg stability through decentralized price feeds.
- **Prediction Markets**: Offering reliable price benchmarks.

## Conclusion
The **DePo Aggregator** is a robust and decentralized price oracle that ensures data integrity through provider validation, deviation checks, and historical tracking. With security mechanisms in place, it serves as a reliable source of on-chain price data for various DeFi applications.

