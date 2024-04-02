//
//  ListCell.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/1/24.
//

import SwiftUI

struct ListCell: View {
    let title: String
    let isFavorite: Bool
    let imageURLString: String

    var body: some View {
        HStack(alignment: .center) {
            if let thumbUrl = URL(string: imageURLString) {
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
                }.frame(width: 50, height: 50)
                .id(imageURLString)
            }
            Text(isFavorite ? "⭐️ \(title)" : title ).padding(EdgeInsets(top: 4, leading: 8, bottom: 8, trailing: 0))
        }
    }
}

#Preview {
    ListCell(title: "Apam balik", isFavorite: true, imageURLString: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        .modelContainer(for: Dessert.self, inMemory: true)
}
