//
//  Ingredient.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/2/24.
//
import Foundation
import SwiftData

@Model
class Ingredient: Identifiable {
    var id = UUID()
    var name: String
    var measurement: String
    var recipe: Recipe?
    
    init(name: String, measurement: String) {
        self.name = name
        self.measurement = measurement
    }
}
