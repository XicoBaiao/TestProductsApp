//
//  ProductDetailView.swift
//  TestProductsApp
//
//  Created by Francisco Baião on 08/12/2024.
//

import Kingfisher
import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                productImageAndRating
            }
            VStack(alignment: .leading) {
                productTitleAndDescription
                productPricingAndStock
                reviewsSection
            }
            .padding()
        }
        .navigationTitle("Details")
    }

    private var productImageAndRating: some View {
        VStack {
            KFImage(URL(string: product.thumbnail ?? ""))
                .placeholder {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                }
                .onFailureImage(UIImage(named: "placeholder"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)

            RatingWithStarsView(rating: product.rating)
                .padding(.top, 8)
        }
    }

    struct RatingWithStarsView: View {
        let rating: Double

        var body: some View {
            HStack(alignment: .center, spacing: 8) {
                Text(String(format: "%.1f", rating))
                    .font(.headline)
                    .foregroundColor(.gray)
                    .baselineOffset(0)

                StarRatingView(rating: rating)
            }
        }
    }


    private var productTitleAndDescription: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.title)
                .font(.largeTitle)
            Text(product.description)
                .font(.body)
        }
    }

    private var productPricingAndStock: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Price: \(String(format: "$%.2f", product.price))")
                Spacer()
                Text("Discount: \(String(format: "%.1f%%", product.discountPercentage))")
            }
            .font(.headline)

            HStack {
                Text("Stock: \(product.stock)")
                Spacer()
                Text("Availability: \(product.availabilityStatus ?? "Unknown")")
            }
            .font(.subheadline)
        }
    }

    private var reviewsSection: some View {
        Group {
            if let reviews = product.reviews, !reviews.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reviews")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)

                    ForEach(reviews, id: \.reviewerEmail) { review in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(review.reviewerName ?? "Anonymous") (\(review.rating ?? 0) ⭐️)")
                                .font(.subheadline)
                            Text(review.comment ?? "No comment provided.")
                                .font(.body)
                        }
                        .padding(.bottom, 8)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
