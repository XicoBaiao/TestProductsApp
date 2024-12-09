//
//  ProductListView.swift
//  TestProductsApp
//
//  Created by Francisco Baião on 08/12/2024.
//

import SwiftUI
import Kingfisher

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(viewModel.products.indices, id: \.self) { index in
                            let product = viewModel.products[index]
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductRowView(product: product)
                            }
                            .onAppear {
                                if index == viewModel.products.count - 1 && viewModel.fetchMode == .paginated {
                                    viewModel.fetchProductsWithPagination()
                                }
                            }
                        }

                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
            .navigationTitle("Products")
        }
    }
}

struct ProductRowView: View {
    let product: Product

    var body: some View {
        HStack {
            KFImage(URL(string: product.thumbnail ?? ""))
                .placeholder {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
                .cancelOnDisappear(true)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))


            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)

                HStack(spacing: 5) {
                    Text("Rating: \(String(format: "%.1f", product.rating))")
                        .font(.subheadline)
                        .foregroundColor(.gray)


                    Image(systemName: "star.fill")
                        .foregroundColor(starColor(for: product.rating))
                        .font(.subheadline)
                }
            }
        }
    }

    // MARK: - Helper Method for Star Color
    private func starColor(for rating: Double) -> Color {
        switch rating {
        case ..<3:
            return .red
        case 3..<4:
            return .yellow
        default:
            return .green
        }
    }
}
