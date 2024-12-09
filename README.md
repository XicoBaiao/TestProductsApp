TestProductsApp

Features

Product List: Displays a list of products fetched from the API.
Product Details: Detailed view of a product, including title, description, price, ratings, reviews, and stock information.
Dynamic Fetching Modes: Fetch all products at once or in paginated chunks, configurable via the fetchMode property.
Offline Caching: Products are cached locally using Realm to allow offline access.
Network Monitoring: Automatically retries fetching data (if no products are found) when the internet connection is restored.
Star Ratings: Displays dynamic star ratings based on the product's rating.

Libraries Used

[SwiftUI]: For building the user interface.
[Combine]: For handling asynchronous operations and binding data to the UI.
[Realm]: For local caching and offline access.
[Kingfisher]: For loading and caching product images efficiently.
[Network]: For monitoring network connectivity using NWPathMonitor.

Project Structure

ProductListView: Displays a list of products with support for both fetch modes.
ProductDetailView: Displays detailed information about a product.
ProductListViewModel: Contains the core business logic, including API integration, caching, and network monitoring.
RealmProduct: Realm object representation of a product for local caching.
NetworkMonitor: Utility class for monitoring network connectivity.

Instructions to Run the App

Clone this repository to your local machine.
Open the project in Xcode and ensure the target scheme is selected.
Run the project using the iOS Simulator or a connected iOS device.

Configuration

The app fetches products from the public API: DummyJSON Products.
You can toggle between fetching modes (allAtOnce or paginated) by modifying the fetchMode in ProductListViewModel.

API Integration

Endpoint: https://dummyjson.com/products
Pagination: Fetch products in chunks of 15 using query parameters ?limit and ?skip.
Caching: All fetched products are stored locally using Realm. The app compares cached products with the total product count from the API to ensure data completeness.


