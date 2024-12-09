//
//  RealmProduct.swift
//  TestProductsApp
//
//  Created by Francisco Baião on 08/12/2024.
//

import RealmSwift

class RealmProduct: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var descriptionText: String
    @Persisted var category: String
    @Persisted var price: Double
    @Persisted var discountPercentage: Double
    @Persisted var rating: Double
    @Persisted var stock: Int
    @Persisted var brand: String
    @Persisted var thumbnail: String
    @Persisted var availabilityStatus: String

    convenience init(from product: Product) {
        self.init()
        self.id = product.id
        self.title = product.title
        self.descriptionText = product.description
        self.category = product.category
        self.price = product.price
        self.discountPercentage = product.discountPercentage
        self.rating = product.rating
        self.stock = product.stock
        self.brand = product.brand ?? ""
        self.thumbnail = product.thumbnail ?? ""
        self.availabilityStatus = product.availabilityStatus ?? "Unknown"
    }

    func toProduct() -> Product {
        return Product(
            id: id,
            title: title,
            description: descriptionText,
            category: category,
            price: price,
            discountPercentage: discountPercentage,
            rating: rating,
            stock: stock,
            tags: [],
            brand: brand,
            sku: "",
            weight: 0,
            dimensions: Dimensions(width: 0, height: 0, depth: 0),
            warrantyInformation: "",
            shippingInformation: "",
            availabilityStatus: availabilityStatus,
            reviews: [],
            returnPolicy: "",
            minimumOrderQuantity: 0,
            meta: MetaData(createdAt: "", updatedAt: "", barcode: "", qrCode: ""),
            images: [],
            thumbnail: thumbnail
        )
    }
}
