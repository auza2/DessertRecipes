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
    
    var desserts = [
        Dessert.sample1,
        Dessert.sample2,
    ]

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                List {
                    ForEach(desserts) { dessert in
                        ListCell(title: dessert.name, isFavorite: true, imageURLString: dessert.imageURLString)
                            .listRowSeparator(.hidden, edges: .all)
                    }
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
