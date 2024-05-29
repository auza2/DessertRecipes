//
//  Text+style.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/3/24.
//

import SwiftUI

extension Text {
    func italicsStyle() -> some View {
        self
            .font(.system(size: 12))
            .foregroundStyle(Color.init(red: 144/255, green: 144/255, blue: 144/255))
            .italic()
    }
    
    func sectionHeaderStyle() -> some View {
        self
            .font(.system(size: 18))
            .fontWeight(.bold)
    }
}
