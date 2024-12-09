//
//  ProductListViewModel.swift
//  TestProductsApp
//
//  Created by Francisco Baião on 08/12/2024.
//

import Combine
import RealmSwift
import Foundation

class ProductListViewModel: ObservableObject {
    enum FetchMode {
        case allAtOnce
        case paginated
    }

    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isConnected: Bool = true

    private var cancellables = Set<AnyCancellable>()
    private let realm = try! Realm()
    private let networkMonitor = NetworkMonitor()

    private let baseURL = "https://dummyjson.com/products"
    private var currentPage: Int = 0
    private let pageSize: Int = 15
    private var hasMoreProducts: Bool = true

    var fetchMode: FetchMode = .paginated

    init() {
        setupNetworkMonitoring()
        loadCachedProducts()
    }

    private func setupNetworkMonitoring() {
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isConnected = isConnected
                if isConnected {
                    self?.retryFetchIfNeeded()
                }
            }
            .store(in: &cancellables)
    }

    private func loadCachedProducts() {
        let cachedProducts = realm.objects(RealmProduct.self)
        products = cachedProducts.map { $0.toProduct() }

        // API call to check if we already have all products locally stored
        guard let url = URL(string: baseURL) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error checking total products: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                if self?.products.count != response.total {
                    self?.fetchProducts()
                }
            }
            .store(in: &cancellables)
    }

    func fetchProducts() {
        products.removeAll()
        switch fetchMode {
        case .allAtOnce:
            fetchAllProducts()
        case .paginated:
            fetchProductsWithPagination()
        }
    }

    func fetchProductsWithPagination() {
        guard !isLoading && hasMoreProducts else { return }

        let skip = currentPage * pageSize
        guard let url = URL(string: "\(baseURL)?limit=\(pageSize)&skip=\(skip)") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        fetch(url: url) { [weak self] response in
            guard let self = self else { return }
            self.products.append(contentsOf: response.products)
            self.saveProductsToRealm(response.products)
            self.currentPage += 1
            self.isLoading = false
            if self.products.count >= response.total {
                self.hasMoreProducts = false
            }
        }
    }

    func fetchAllProducts() {
        guard !isLoading else { return }

        isLoading = true
        products.removeAll()
        currentPage = 0

        fetchAllPages(skip: 0, accumulatedProducts: [])
    }

    private func fetchAllPages(skip: Int, accumulatedProducts: [Product]) {
        guard let url = URL(string: "\(baseURL)?limit=\(pageSize)&skip=\(skip)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        fetch(url: url) { [weak self] response in
            guard let self = self else { return }
            let combinedProducts = accumulatedProducts + response.products

            if combinedProducts.count >= response.total || response.products.isEmpty {
                self.products = combinedProducts
                self.saveProductsToRealm(combinedProducts)
                self.isLoading = false
                print("All products fetched successfully: \(combinedProducts.count)")
            } else {
                self.fetchAllPages(skip: skip + self.pageSize, accumulatedProducts: combinedProducts)
            }
        }
    }

    private func fetch(url: URL, completion: @escaping (ProductResponse) -> Void) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completionResult in
                if case let .failure(error) = completionResult {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                    print("Error: \(error)")
                    self?.isLoading = false
                }
            } receiveValue: { response in
                completion(response)
            }
            .store(in: &cancellables)
    }

    private func saveProductsToRealm(_ products: [Product]) {
        do {
            try realm.write {
                let realmProducts = products.map { RealmProduct(from: $0) }
                realm.add(realmProducts, update: .all)
            }
        } catch {
            errorMessage = "Failed to save products locally: \(error.localizedDescription)"
        }
    }

    private func retryFetchIfNeeded() {
        if products.isEmpty {
            fetchProducts()
        }
    }
}
