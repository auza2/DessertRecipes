//
//  IngredientListCell.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/3/24.
//

import SwiftUI

struct IngredientListCell: View {
    @State var isChecked: Bool = false
    let ingredient: Ingredient
    
    var body: some View {
        HStack {
            if(isChecked) {
                Button {
                    toggleIsChecked()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                }
            } else {
                Button {
                    toggleIsChecked()
                } label: {
                    Image(systemName: "circle")
                }
            }
            Text("\(ingredient.measurement) \(ingredient.name)")
                .font(.system(size: 12))
                .listRowSeparator(.hidden)
        }
    }
    
    func toggleIsChecked() {
        isChecked = !isChecked
    }
}
