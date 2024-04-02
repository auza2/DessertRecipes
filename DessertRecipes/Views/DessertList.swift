//
//  DessertList.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/1/24.
//

import SwiftUI
import SwiftData

struct DessertList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Dessert]

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                List {
                    ListCell(title: "Apam balik", isFavorite: true, imageURLString: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
                }
            }.navigationTitle("Desserts")
        }.listStyle(.grouped)
        .padding(.top, -35)
        .environment(\.defaultMinListRowHeight, 10)
    }
}

#Preview {
    DessertList()
        .modelContainer(for: Dessert.self, inMemory: true)
}
