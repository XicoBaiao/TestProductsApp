//
//  ProductModel.swift
//  TestProductsApp
//
//  Created by Francisco Baião on 08/12/2024.
//

struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let tags: [String]?
    let brand: String?
    let sku: String?
    let weight: Int?
    let dimensions: Dimensions?
    let warrantyInformation: String?
    let shippingInformation: String?
    let availabilityStatus: String?
    let reviews: [Review]?
    let returnPolicy: String?
    let minimumOrderQuantity: Int?
    let meta: MetaData?
    let images: [String]?
    let thumbnail: String?

}

struct Dimensions: Codable {
    let width: Double?
    let height: Double?
    let depth: Double?
}

struct Review: Codable {
    let rating: Int?
    let comment: String?
    let date: String?
    let reviewerName: String?
    let reviewerEmail: String?
}

struct MetaData: Codable {
    let createdAt: String?
    let updatedAt: String?
    let barcode: String?
    let qrCode: String?
}
