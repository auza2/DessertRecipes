//
//  Dessert.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/1/24.
//
import SwiftData

@Model
class Dessert{
    @Attribute(.unique) var id: String
    var name: String
    var imageURLString: String
    
    init(id: String, name: String, imageURLString: String) {
        self.id = id
        self.name = name
        self.imageURLString = imageURLString
    }
}
