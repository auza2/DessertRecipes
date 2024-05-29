//
//  Recipe.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/2/24.
//
import Foundation
import SwiftData

@Model
class Recipe: Decodable {
    @Attribute(.unique) var id = UUID()
    var mealId: String
    var name: String
    var imageURLString: String
    var instructions: String
    var tags: String?
    var cuisine: String
    var ingredients: [Ingredient]?
    var videoId: String?
    var sourceURLString: String?
    
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
    
    enum CodingKeys: String, CodingKey {
        case mealId = "idMeal"
        case name = "strMeal"
        case imageURLString = "strMealThumb"
        case instructions = "strInstructions"
        case cuisine = "strArea"
        case tags = "strTags"
        case youtubeURL = "strYoutube"
        
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
        
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
    }
    
    static let sample1 = Recipe(mealId: "1", name: "Apam balik", imageURLString: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg", instructions: "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.", tags: "Cake,Treat,Sweet", cuisine: "Malaysian", ingredients: [Ingredient(name: "Vegetable Oil", measurement: "450ml"), Ingredient(name: "Flour", measurement: "400g")])
    static let sample2 = Recipe(mealId: "2", name: "Apple & Blackberry Crumble", imageURLString: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg", instructions: "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\r\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and melt together over a medium heat. Cook for 3 mins until the mixture turns to a light caramel. Stir in the apples and cook for 3 mins. Add the blackberries and cinnamon, and cook for 3 mins more. Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.\r\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with vanilla ice cream.", cuisine: "British", ingredients: [])
    
    init(mealId: String, name: String, imageURLString: String, instructions: String, tags: String? = nil, cuisine: String, ingredients: [Ingredient] = [], videoId: String? = nil, sourceURLString: String? = nil) {
        self.mealId = mealId
        self.name = name
        self.imageURLString = imageURLString
        self.instructions = instructions
        self.tags = tags
        self.cuisine = cuisine
        self.ingredients = ingredients
        self.videoId = videoId
        self.sourceURLString = sourceURLString
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.mealId = try values.decodeIfPresent(String.self, forKey: .mealId) ?? ""
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.imageURLString = try values.decodeIfPresent(String.self, forKey: .imageURLString) ?? ""
        self.instructions = try values.decodeIfPresent(String.self, forKey: .instructions) ?? ""
        self.cuisine = try values.decodeIfPresent(String.self, forKey: .cuisine) ?? ""
        self.tags = try values.decodeIfPresent(String.self, forKey: .tags)
        
        let youtubeURL = try? values.decodeIfPresent(String.self, forKey: .youtubeURL)
        
        if let youtubeURL = youtubeURL {
            self.videoId = youtubeURL.components(separatedBy: "v=")[1]
        }
        
        self.strIngredient1 = try values.decodeIfPresent(String.self, forKey: .strIngredient1) ?? ""
        self.strIngredient2 = try values.decodeIfPresent(String.self, forKey: .strIngredient2) ?? ""
        self.strIngredient3 = try values.decodeIfPresent(String.self, forKey: .strIngredient3) ?? ""
        self.strIngredient4 = try values.decodeIfPresent(String.self, forKey: .strIngredient4) ?? ""
        self.strIngredient5 = try values.decodeIfPresent(String.self, forKey: .strIngredient5) ?? ""
        self.strIngredient6 = try values.decodeIfPresent(String.self, forKey: .strIngredient6) ?? ""
        self.strIngredient7 = try values.decodeIfPresent(String.self, forKey: .strIngredient7) ?? ""
        self.strIngredient8 = try values.decodeIfPresent(String.self, forKey: .strIngredient8) ?? ""
        self.strIngredient9 = try values.decodeIfPresent(String.self, forKey: .strIngredient9) ?? ""
        self.strIngredient10 = try values.decodeIfPresent(String.self, forKey: .strIngredient10) ?? ""
        self.strIngredient11 = try values.decodeIfPresent(String.self, forKey: .strIngredient11) ?? ""
        self.strIngredient12 = try values.decodeIfPresent(String.self, forKey: .strIngredient12) ?? ""
        self.strIngredient13 = try values.decodeIfPresent(String.self, forKey: .strIngredient13) ?? ""
        self.strIngredient14 = try values.decodeIfPresent(String.self, forKey: .strIngredient14) ?? ""
        self.strIngredient15 = try values.decodeIfPresent(String.self, forKey: .strIngredient15) ?? ""
        self.strIngredient16 = try values.decodeIfPresent(String.self, forKey: .strIngredient16) ?? ""
        self.strIngredient17 = try values.decodeIfPresent(String.self, forKey: .strIngredient17) ?? ""
        self.strIngredient18 = try values.decodeIfPresent(String.self, forKey: .strIngredient18) ?? ""
        self.strIngredient19 = try values.decodeIfPresent(String.self, forKey: .strIngredient19) ?? ""
        self.strIngredient20 = try values.decodeIfPresent(String.self, forKey: .strIngredient20) ?? ""
        
        self.strMeasure1 = try values.decodeIfPresent(String.self, forKey: .strMeasure1) ?? ""
        self.strMeasure2 = try values.decodeIfPresent(String.self, forKey: .strMeasure2) ?? ""
        self.strMeasure3 = try values.decodeIfPresent(String.self, forKey: .strMeasure3) ?? ""
        self.strMeasure4 = try values.decodeIfPresent(String.self, forKey: .strMeasure4) ?? ""
        self.strMeasure5 = try values.decodeIfPresent(String.self, forKey: .strMeasure5) ?? ""
        self.strMeasure6 = try values.decodeIfPresent(String.self, forKey: .strMeasure6) ?? ""
        self.strMeasure7 = try values.decodeIfPresent(String.self, forKey: .strMeasure7) ?? ""
        self.strMeasure8 = try values.decodeIfPresent(String.self, forKey: .strMeasure8) ?? ""
        self.strMeasure9 = try values.decodeIfPresent(String.self, forKey: .strMeasure9) ?? ""
        self.strMeasure10 = try values.decodeIfPresent(String.self, forKey: .strMeasure10) ?? ""
        self.strMeasure11 = try values.decodeIfPresent(String.self, forKey: .strMeasure11) ?? ""
        self.strMeasure12 = try values.decodeIfPresent(String.self, forKey: .strMeasure12) ?? ""
        self.strMeasure13 = try values.decodeIfPresent(String.self, forKey: .strMeasure13) ?? ""
        self.strMeasure14 = try values.decodeIfPresent(String.self, forKey: .strMeasure14) ?? ""
        self.strMeasure15 = try values.decodeIfPresent(String.self, forKey: .strMeasure15) ?? ""
        self.strMeasure16 = try values.decodeIfPresent(String.self, forKey: .strMeasure16) ?? ""
        self.strMeasure17 = try values.decodeIfPresent(String.self, forKey: .strMeasure17) ?? ""
        self.strMeasure18 = try values.decodeIfPresent(String.self, forKey: .strMeasure18) ?? ""
        self.strMeasure19 = try values.decodeIfPresent(String.self, forKey: .strMeasure19) ?? ""
        self.strMeasure20 = try values.decodeIfPresent(String.self, forKey: .strMeasure20) ?? ""
    }
}

extension Recipe {
    subscript(strIngredient i: Int) -> String? {
        switch i {
        case 1: return strIngredient1
        case 2: return strIngredient2
        case 3: return strIngredient3
        case 4: return strIngredient4
        case 5: return strIngredient5
        case 6: return strIngredient6
        case 7: return strIngredient7
        case 8: return strIngredient8
        case 9: return strIngredient9
        case 10: return strIngredient10
        case 11: return strIngredient11
        case 12: return strIngredient12
        case 13: return strIngredient13
        case 14: return strIngredient14
        case 15: return strIngredient15
        case 16: return strIngredient16
        case 17: return strIngredient17
        case 18: return strIngredient18
        case 19: return strIngredient19
        case 20: return strIngredient20
        default: return nil
        }
    }

    subscript(strMeasure i: Int) -> String? {
        switch i {
        case 1: return strMeasure1
        case 2: return strMeasure2
        case 3: return strMeasure3
        case 4: return strMeasure4
        case 5: return strMeasure5
        case 6: return strMeasure6
        case 7: return strMeasure7
        case 8: return strMeasure8
        case 9: return strMeasure9
        case 10: return strMeasure10
        case 11: return strMeasure11
        case 12: return strMeasure12
        case 13: return strMeasure13
        case 14: return strMeasure14
        case 15: return strMeasure15
        case 16: return strMeasure16
        case 17: return strMeasure17
        case 18: return strMeasure18
        case 19: return strMeasure19
        case 20: return strMeasure20
        default: return nil
        }
    }
}

