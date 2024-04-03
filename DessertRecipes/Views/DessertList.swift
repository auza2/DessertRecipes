//
//  DessertList.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/1/24.
//

import SwiftUI
import SwiftData

struct DessertList: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Dessert.name) var desserts: [Dessert]
    @State private var searchText = ""
    
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
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                DessertsView(searchString: searchText)
            }
            .navigationTitle("Desserts")
            .searchable(text: $searchText)
        }
        .listStyle(.grouped)
        .padding(.top, -35)
        .environment(\.defaultMinListRowHeight, 10)
        .task {
            await fetchDesserts()
        }
    }
    
    func fetchDesserts() async {
        do {
            let data = try await SessionManager().perform(DessertsRequest.getDesserts)
            let desserts = try parseData(data: data)
            try persistDesserts(desserts: desserts)
        } catch {
            
        }
    }
    
    private func parseData(data: Data) throws -> [Dessert] {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsonDictionary = json as? [String: Any] else { return [] }

        let meals = jsonDictionary["meals"] as? [Any]
        var desserts  = [Dessert]()
        
        for dessertDictionary in meals as! [Dictionary<String, AnyObject>] {
            let id = dessertDictionary["idMeal"] as? String ?? ""
            let name = dessertDictionary["strMeal"] as? String ?? ""
            let strMealThumb = dessertDictionary["strMealThumb"] as? String ?? ""
            
            let dessert = Dessert(id: id, name: name, imageURLString: strMealThumb)
            
            desserts.append(dessert)
        }
        
        return desserts
    }
    
    private func persistDesserts(desserts: [Dessert]) throws {
        modelContext.autosaveEnabled = false
        
        try modelContext.transaction {
            for fetchedDessert in desserts {
                let fetchedDessertId = fetchedDessert.id
                let predicate = #Predicate<Dessert> { dessert in
                    dessert.id == fetchedDessertId
                }
                
                var descriptor = FetchDescriptor(predicate: predicate)
                descriptor.fetchLimit = 1
                
                // Check if Dessert is a duplicate
                // if no duplicates found insert to model context
                do {
                    let duplicate = try modelContext.fetch(descriptor)
                    
                    if(duplicate.count == 0) {
                        modelContext.insert(fetchedDessert)
                    }
                } catch {
                    modelContext.insert(fetchedDessert)
                }
            }
            
            try modelContext.save()
        }
    }
}
