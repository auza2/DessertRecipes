//
//  DessertsRequest.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/2/24.
//

import Foundation

enum DessertsRequest: RequestProtocol {
    case getDesserts
    case getRecipe(String)
    
    var path: String {
        switch self {
        case .getDesserts:
            "/api/json/v1/1/filter.php"
        case .getRecipe:
            "/api/json/v1/1/lookup.php"
        }
    }
    
    var urlParams: [String: String?] {
        switch self {
        case .getDesserts:
            return ["c": "Dessert"]
        case .getRecipe(let id):
            return ["i": id]
        }
    }
    
    var requestType: RequestType {
        .GET
    }

}
