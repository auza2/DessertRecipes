//
//  DessertsView.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/3/24.
//

import SwiftUI
import SwiftData

struct DessertsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var desserts: [Dessert]
    
    var favorites: [Dessert] {
            get {
                return desserts.filter{$0.isFavorite == true}
            }
        }
    var otherDesserts: [Dessert] {
            get {
                return desserts.filter{$0.isFavorite == false}
            }
        }
    
    init(searchString: String = "", sortOrder: [SortDescriptor<Dessert>] = []) {
        _desserts = Query(filter: #Predicate { dessert in
            if searchString.isEmpty {
                true
            } else {
                dessert.name.localizedStandardContains(searchString)
            }
        }, sort: [SortDescriptor(\Dessert.name)])
    }
    
    var body: some View {
        List {
            Section("Favorites") {
                ForEach(favorites) { dessert in
                    VStack{
                        NavigationLink(destination: RecipeDetailView(dessert: dessert)) {
                            DessertListCell(dessert: dessert)
                            
                        }
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                        return 0
                    }
                }
            }
            Section("Other Desserts") {
                ForEach(otherDesserts) { dessert in
                    VStack{
                        NavigationLink(destination: RecipeDetailView(dessert: dessert)) {
                            DessertListCell(dessert: dessert)
                            
                        }
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                        return 0
                    }
                }
            }
        }
    }
}
