//
//  StarRatingView.swift
//  TestProductsApp
//
//  Created by Francisco Baião on 09/12/2024.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Double
    let maxRating: Int = 5

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maxRating, id: \.self) { index in
                star(for: index)
                    .frame(width: 20, height: 20)
            }
        }
    }

    private func star(for index: Int) -> some View {
        let starValue = Double(index + 1)
        let fractionalPart = rating - floor(rating)

        if rating >= starValue {
            return Image(systemName: "star.fill")
                .foregroundColor(.yellow)
        } else if starValue - rating <= 1 {
            if fractionalPart >= 0.7 {
                return Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            } else if fractionalPart >= 0.3 {
                return Image(systemName: "star.leadinghalf.filled")
                    .foregroundColor(.yellow)
            } else {
                return Image(systemName: "star")
                    .foregroundColor(.gray)
            }
        } else {
            return Image(systemName: "star")
                .foregroundColor(.gray)
        }
    }
}

