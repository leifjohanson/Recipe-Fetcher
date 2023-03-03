//
//  RecipeModel.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 2/25/23.
//

import Foundation

struct RecipeModel {
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strIngredients: [String]
    let strMeasures: [String]
    
    func getIngredients() -> [[String]] {
        var arrangedIngredients: [[String]] = []
        
        for i in 0...strIngredients.count {
            if (strIngredients[i] == "" || strMeasures[i] == "") {
                return arrangedIngredients
            }
            
            arrangedIngredients.append([strIngredients[i], strMeasures[i]])
        }
        
        return arrangedIngredients
    }
    
    func getInstructions() -> [String] {
        var instructionArray = strInstructions.components(separatedBy: "\r\n")
        
        // Filters all remaining empty lines
        instructionArray = instructionArray.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        // Filters all instructions that are just one character (some recipes from the API - such as Beef Banh Mi Bowls, have single numbers as instructions (which are supposed to represent step numbers)
        instructionArray = instructionArray.filter { $0.count > 1 }
        
        return instructionArray
    }
}

