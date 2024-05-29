//
//  RecipeResponse.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 5/23/24.
//

import Foundation
import SwiftData

struct RecipeResponse: Decodable {
    let recipe: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recipe = try container.decode([Recipe].self, forKey: .meals)
    }
}
