//
//  Recipe.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/2/24.
//
import Foundation
import SwiftData

@Model
class Recipe {
    @Attribute(.unique) var id = UUID()
    var mealId: String
    var name: String
    var imageURLString: String
    var instructions: String
    var tags: String?
    var cuisine: String
    var ingredients: [Ingredient]?
    var videoId: String?
    
    static let sample1 = Recipe(mealId: "1", name: "Apam balik", imageURLString: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg", instructions: "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.", tags: "Cake,Treat,Sweet", cuisine: "Malaysian", ingredients: [Ingredient(name: "Vegetable Oil", measurement: "450ml"), Ingredient(name: "Flour", measurement: "400g")])
    static let sample2 = Recipe(mealId: "2", name: "Apple & Blackberry Crumble", imageURLString: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg", instructions: "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\r\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and melt together over a medium heat. Cook for 3 mins until the mixture turns to a light caramel. Stir in the apples and cook for 3 mins. Add the blackberries and cinnamon, and cook for 3 mins more. Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.\r\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with vanilla ice cream.", cuisine: "British", ingredients: [])
    
    init(mealId: String, name: String, imageURLString: String, instructions: String, tags: String? = nil, cuisine: String, ingredients: [Ingredient] = [], videoId: String? = nil) {
        self.mealId = mealId
        self.name = name
        self.imageURLString = imageURLString
        self.instructions = instructions
        self.tags = tags
        self.cuisine = cuisine
        self.ingredients = ingredients
        self.videoId = videoId
    }
}

