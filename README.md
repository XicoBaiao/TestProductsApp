# TestProductsApp

## Architecture: MVVM
- **Model**:
  - Represents the data and business logic.
  - Product, ProductResponse, and Realm models (RealmProduct).
- **View**:
  - Responsible for the UI and displaying data to the user.
  - ProductListView and ProductDetailView.
- **ViewModel**:
  - Acts as the intermediary between the View and the Model.
  - ProductListViewModel, which fetches data from APIs, manages caching with Realm, and handles network monitoring.

## Features
- **Product List**: Displays a list of products fetched from the API.
- **Product Details**: Detailed view of a product, including title, description, price, ratings, reviews, and stock information.
- **Dynamic Fetching Modes**: Fetch all products at once or in paginated chunks, configurable via the `fetchMode` property.
- **Offline Caching**: Products are cached locally using Realm to allow offline access.
- **Network Monitoring**: Automatically retries fetching data (if no products are found) when the internet connection is restored.
- **Star Ratings**: Displays dynamic star ratings based on the product's rating.

## Libraries Used
- **[SwiftUI]**: For building the user interface.
- **[Combine]**: For handling asynchronous operations and binding data to the UI.
- **[Realm]**: For local caching and offline access.
- **[Kingfisher]**: For loading and caching product images efficiently.
- **[Network]**: For monitoring network connectivity using `NWPathMonitor`.

## Project Structure
- **`ProductListView`**: Displays a list of products with support for both fetch modes.
- **`ProductDetailView`**: Displays detailed information about a product.
- **`ProductListViewModel`**: Contains the core business logic, including API integration, caching, and network monitoring.
- **`RealmProduct`**: Realm object representation of a product for local caching.
- **`NetworkMonitor`**: Utility class for monitoring network connectivity.

## Instructions to Run the App
1. Clone this repository to your local machine.
2. Open the project in Xcode or double-click TestProductsApp.xcodeproj in root directory and ensure the target scheme is selected.
3. Run the project using the iOS Simulator or a connected iOS device.

## Configuration
- The app fetches products from the public API: [DummyJSON Products](https://dummyjson.com/products).
- You can toggle between fetching modes (`allAtOnce` or `paginated`) by modifying the `fetchMode` in `ProductListViewModel`.

## API Integration
- **Endpoint**: `https://dummyjson.com/products`
- **Pagination**: Fetch products in chunks of 15 using query parameters `?limit` and `?skip`.
- **Caching**: All fetched products are stored locally using Realm. The app compares cached products with the total product count from the API to ensure data completeness.

## Note on Network Monitoring
- The app uses NWPathMonitor from the Network framework to monitor internet connectivity. However, I found a discrepancy in the behavior of NWPathMonitor when running on a simulator versus a physical device:

- **On a physical device**:
  - path.status returns .unsatisfied when the Wi-Fi is turned off.
  - path.status returns .satisfied when the Wi-Fi is turned on.
    
- **On a simulator**:
  - path.status returns .satisfied when the Wi-Fi is turned off.
  - path.status returns .unsatisfied when the Wi-Fi is turned on.

- To handle this, the app dynamically detects whether it is running on a simulator or a physical device and adjusts the logic accordingly to ensure consistent network connectivity detection.
