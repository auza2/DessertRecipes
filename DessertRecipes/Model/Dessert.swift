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
    var isFavorite: Bool
    
    static let sample1 = Dessert(id: "1", name: "Apam balik", imageURLString: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
    static let sample2 = Dessert(id: "2", name: "Apple & Blackberry Crumble", imageURLString: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")
    
    init(id: String, name: String, imageURLString: String, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.imageURLString = imageURLString
        self.isFavorite = isFavorite
    }
}
