//
//  DessertResponse.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 5/23/24.
//
import SwiftData

struct DessertResponse: Decodable {
    let desserts: [Dessert]
    
    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.desserts = try container.decode([Dessert].self, forKey: .meals)
    }
}
