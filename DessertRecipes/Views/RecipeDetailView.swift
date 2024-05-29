//
//  DessertDetailView.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/2/24.
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var dessert: Dessert
    @Query var recipes: [Recipe]
    var recipe: Recipe? {
        recipes.first
    }
    
    var fullDivider: some View {
        return Divider()
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
    }
    
    init(dessert: Dessert) {
        self.dessert = dessert
        let dessertId = dessert.id
        _recipes = Query(filter: #Predicate{ recipe in
            recipe.mealId == dessertId
        })
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if let recipe = recipe {
                List {
                    if let thumbUrl = URL(string: recipe.imageURLString) {
                        CacheAsyncImage(url: thumbUrl,
                                        scale: 3,
                                        transaction: Transaction(animation: .easeIn)) { phase in
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
                                        .frame(height: UIScreen.main.bounds.width)
                                        .id(recipe.imageURLString)
                                        .listRowInsets(EdgeInsets())
                    }
                    
                    VStack(alignment: .leading) {
                        if let sourceURLString = recipe.sourceURLString {
                            Link("Link to Source", destination: URL(string: sourceURLString)!)
                        }
                        if let tags = recipe.tags {
                            Text("Tags: \(tags)").italicsStyle()
                        }
                        Text("Cuisine: \(recipe.cuisine)").italicsStyle()
                    }.listRowSeparator(.hidden)
                    
                    fullDivider
                    
                    Text("Ingredients")
                        .sectionHeaderStyle()
                    if let ingredients = recipe.ingredients {
                        ForEach(ingredients) { ingredient in
                            IngredientListCell(isChecked: false, ingredient: ingredient)
                                .listRowSeparator(.hidden)
                        }
                    }
                    
                    fullDivider
                    
                    Text("Instructions")
                        .sectionHeaderStyle()
                    Text(recipe.instructions)
                        .font(.system(size: 12))
                        .listRowSeparator(.hidden)
                    
                    fullDivider
                    
                    if let videoId = recipe.videoId {
                        Text("Video")
                            .sectionHeaderStyle()
                        
                        VideoView(videoId: videoId)
                            .frame(minWidth: 0, minHeight: UIScreen.main.bounds.height*0.3)
                            .listRowSeparator(.hidden)
                    }
                    
                    Spacer()
                        .frame(height: 0)
                        
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(recipe.name).font(.headline)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if(dessert.isFavorite) {
                    Button(action: favorite) {
                        Label("Add Item", systemImage: "star.fill")
                    }.tint(.yellow)
                } else {
                    Button(action: favorite) {
                        Label("Add Item", systemImage: "star")
                    }.tint(.yellow)
                }
            }
        }
        .task {
            await fetchRecipe()
        }
    }
    
    func fetchRecipe() async {
        if ( recipe != nil ) { return }
        
        modelContext.autosaveEnabled = false
        do {
            let data = try await SessionManager().perform(DessertsRequest.getRecipe(dessert.id))
            let fetchedRecipe = try parseRecipe(data: data)
            if let fetchedRecipe = fetchedRecipe {
                try persistRecipe(recipe: fetchedRecipe)
            }
        } catch {
            print("Error occurred")
        }
    }
    
    func favorite() {
        dessert.isFavorite = dessert.isFavorite ? false : true
        do {
            try modelContext.save()
        } catch {
            print("Error occurred")
        }
    }
    
    private func parseRecipe(data: Data) throws -> Recipe? {
        let recipeResponse = try! JSONDecoder().decode(RecipeResponse.self, from: data)
        
        if let recipe = recipeResponse.recipe.first {
            recipe.ingredients = (1...20).compactMap({ i in
                guard let ingredient = recipe[keyPath: \Recipe[strMeasure: i]],
                      let measure = recipe[keyPath: \Recipe[strIngredient: i]],
                        !ingredient.isEmpty, !measure.isEmpty else { return nil}

                    return Ingredient(name: ingredient, measurement: measure)
            })
        }
        
        return recipeResponse.recipe.first
    }
    
    private func persistRecipe(recipe: Recipe) throws {
        try modelContext.transaction {
            modelContext.insert(recipe)
            try modelContext.save()
        }
    }
}
