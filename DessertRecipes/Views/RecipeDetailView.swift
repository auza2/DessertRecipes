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
    @State var recipe: Recipe?
    
    init(dessert: Dessert) {
        self.dessert = dessert
    }
    
    var body: some View {
        NavigationView {
            if let recipe = recipe {
                ZStack(alignment: .top) {
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
                                            .frame(height: 260)
                                            .id(recipe.imageURLString)
                                            .listRowInsets(EdgeInsets())
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Link to Source")
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .foregroundStyle(Color.init(red: 94/255, green: 108/255, blue: 226/255))
                            
                            if let tags = recipe.tags {
                                Text("Tags: \(tags)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.init(red: 144/255, green: 144/255, blue: 144/255))
                                    .italic()
                            }
                            
                            Text("Cuisine: \(recipe.cuisine)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.init(red: 144/255, green: 144/255, blue: 144/255))
                                .italic()
                            
                        }
                        
                        Text("Ingredients")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        if let ingredients = recipe.ingredients {
                            ForEach(ingredients) { ingredient in
                                HStack {
                                    Text("\(ingredient.measurement) \(ingredient.name)")
                                        .font(.system(size: 12))
                                }
                            }
                        }
                        
                        Text("Instructions")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        
                        Text(recipe.instructions)
                            .font(.system(size: 12))
                        
                        
                    }
                }
                .navigationTitle(recipe.name)
            }
        }
        .listStyle(.grouped)
        .padding(.top, -35)
        .environment(\.defaultMinListRowHeight, 10)
        .task {
            await fetchRecipe()
        }
    }
    
    func fetchRecipe() async {
        modelContext.autosaveEnabled = false
        
        do {
            let data = try await SessionManager().perform(DessertsRequest.getRecipe(dessert.id))
            let fetchedRecipe = try parseData(data: data)
            // TODO: Persist Recipe
        } catch {
            // TODO: Figure out Error Scenario UI
        }
    }
    
    private func parseData(data: Data) throws -> Recipe? {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsonDictionary = json as? [String: Any], let meals = jsonDictionary["meals"] as? [Any] else { return nil }

        for recipeDictionary in meals as! [Dictionary<String, AnyObject>] {
            let id = recipeDictionary["idMeal"] as? String ?? ""
            let name = recipeDictionary["strMeal"] as? String ?? ""
            let strMealThumb = recipeDictionary["strMealThumb"] as? String ?? ""
            let instructions = recipeDictionary["strInstructions"] as? String ?? ""
            let cuisine = recipeDictionary["strArea"] as? String ?? ""
            let tags = recipeDictionary["strTags"] as? String
            
            let ingredients = try parseIngredients(recipeDictionary: recipeDictionary)
            
            let fetchedRecipe = Recipe(id: id, name: name, imageURLString: strMealThumb, instructions: instructions, tags: tags, cuisine: cuisine, ingredients: ingredients)

            print(fetchedRecipe.ingredients)
            
            self.recipe = fetchedRecipe // TODO: Remove once we persist
            
            return fetchedRecipe
        }
        
        return nil
    }
    
    private func parseIngredients(recipeDictionary: [String : AnyObject]) throws -> [Ingredient] {
        var ingredients = [Ingredient]()
        
        try modelContext.transaction {
            var ingredientIndex = 1
            
            while(true) {
                if let ingredient = recipeDictionary["strIngredient\(ingredientIndex)"] as? String,  let measurement = recipeDictionary["strMeasure\(ingredientIndex)"] as? String {
                    let ingredientString = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
                    let measurementString = measurement.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if !ingredientString.isEmpty && !measurementString.isEmpty {
                        let ingredient = Ingredient(name: ingredientString, measurement: measurementString)
                        ingredients.append(ingredient)
                        modelContext.insert(ingredient)
                    }
                    
                    ingredientIndex += 1
                } else {
                    break
                }
            }
            
            try modelContext.save()
        }
        
        return ingredients
    }
    
    private func persistRecipe(recipe: Recipe) throws {
        try modelContext.transaction {
            let fetchedRecipeId = recipe.id
            let predicate = #Predicate<Recipe> { recipe in
                recipe.id == fetchedRecipeId
            }
            
            var descriptor = FetchDescriptor(predicate: predicate)
            descriptor.fetchLimit = 1
            
            // Check if Recipe is a duplicate
            // if no duplicates found insert to model context
            do {
                let duplicate = try modelContext.fetch(descriptor)
                
                if(duplicate.count == 0) {
                    if let ingredients = recipe.ingredients {
                        for ingredient in ingredients {
                            modelContext.insert(ingredient)
                        }
                    }
                    
                    modelContext.insert(recipe)
                }
            } catch {
                if let ingredients = recipe.ingredients {
                    for ingredient in ingredients {
                        modelContext.insert(ingredient)
                    }
                }
                modelContext.insert(recipe)
            }
            
            
            try modelContext.save()
        }
    }
}

#Preview {
    RecipeDetailView(dessert: Dessert.sample1).modelContainer(for: Dessert.self, inMemory: true)
}
