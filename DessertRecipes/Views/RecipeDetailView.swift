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
                        
                    }.listRowSeparator(.hidden)
                    
                    fullDivider
                    
                    Text("Ingredients")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    if let ingredients = recipe.ingredients {
                        ForEach(ingredients) { ingredient in
                            Text("\(ingredient.measurement) \(ingredient.name)")
                                .font(.system(size: 12))
                                .listRowSeparator(.hidden)
                                
                        }
                    }
                    
                    fullDivider
                    
                    Text("Instructions")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    Text(recipe.instructions)
                        .font(.system(size: 12))
                        .listRowSeparator(.hidden)
                    
                    fullDivider
                    
                    if let videoId = recipe.videoId {
                        Text("Video")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .listRowSeparator(.hidden)
                        
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
        .onAppear {
            if let ingredients = recipe?.ingredients {
                print("On appear: Ingredient count \(ingredients.count)")
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
            // TODO: Figure out Error Scenario UI
        }
    }
    
    func favorite() {
        dessert.isFavorite = dessert.isFavorite ? false : true
        do {
            try modelContext.save()
        } catch {
            
        }
    }
    
    private func parseRecipe(data: Data) throws -> Recipe? {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsonDictionary = json as? [String: Any], let meals = jsonDictionary["meals"] as? [Any] else { return nil }

        for recipeDictionary in meals as! [Dictionary<String, AnyObject>] {
            let id = recipeDictionary["idMeal"] as? String ?? ""
            let name = recipeDictionary["strMeal"] as? String ?? ""
            let strMealThumb = recipeDictionary["strMealThumb"] as? String ?? ""
            let instructions = recipeDictionary["strInstructions"] as? String ?? ""
            let cuisine = recipeDictionary["strArea"] as? String ?? ""
            let tags = recipeDictionary["strTags"] as? String
            let youtubeURL = recipeDictionary["strYoutube"] as? String
            
            var videoId: String?
            if let youtubeURL = youtubeURL {
                videoId = youtubeURL.components(separatedBy: "v=")[1]
            }
            
            let ingredients = try parseIngredients(recipeDictionary: recipeDictionary)
            let fetchedRecipe = Recipe(mealId: id, name: name, imageURLString: strMealThumb, instructions: instructions, tags: tags, cuisine: cuisine, ingredients: ingredients, videoId: videoId)

            return fetchedRecipe
        }
        
        return nil
    }
    
    private func parseIngredients(recipeDictionary: [String : AnyObject]) throws -> [Ingredient] {
        var ingredients = [Ingredient]()
        modelContext.autosaveEnabled = false
        
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
        
        return ingredients
    }
    
    private func persistRecipe(recipe: Recipe) throws {
        try modelContext.transaction {
            modelContext.insert(recipe)
            try modelContext.save()
        }
    }
}

#Preview {
    RecipeDetailView(dessert: Dessert.sample1).modelContainer(for: Dessert.self, inMemory: true)
}
