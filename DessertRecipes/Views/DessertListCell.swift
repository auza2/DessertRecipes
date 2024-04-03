//
//  DessertListCell.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/1/24.
//

import SwiftUI

struct DessertListCell: View {
    @Bindable var dessert: Dessert

    var body: some View {
        HStack(alignment: .center) {
            if let thumbUrl = URL(string: dessert.imageURLString) {
                CacheAsyncImage(url: thumbUrl,
                                scale: 3, transaction: Transaction(animation: .easeIn)) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray
                            ProgressView()
                        }
                    case .success(let image):
                        image.resizable()
                    case .failure(let error):
                        Text(error.localizedDescription)
              
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                .id(dessert.imageURLString)
            }
            Text(dessert.isFavorite ? "⭐️" : " " )
            Text(dessert.name)
        }
    }
}
