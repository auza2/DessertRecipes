//
//  DessertRecipesApp.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/1/24.
//

import SwiftUI
import SwiftData

@main
struct DessertRecipesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Dessert.self,
            Recipe.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            DessertList()
        }
        .modelContainer(sharedModelContainer)
    }
}
