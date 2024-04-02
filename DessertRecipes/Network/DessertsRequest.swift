//
//  DessertsRequest.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/2/24.
//

import Foundation

enum DessertsRequest: RequestProtocol {
    case getDesserts
    
    var path: String {
        "/api/json/v1/1/filter.php"
    }
    
    var urlParams: [String: String?] {
        switch self {
        case .getDesserts:
            return ["c":"Dessert"]
        }
    }
    
    var requestType: RequestType {
        .GET
    }

}
