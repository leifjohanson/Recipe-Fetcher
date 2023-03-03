//
//  RecipeManager.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 2/25/23.
//

import Foundation
import CloudKit

protocol RecipeManagerDelegate {
    func didUpdateRecipes(_ recipeManager: RecipeManager, recipe: RecipeModel)
    func didFailWithError(error: Error)
}

struct RecipeManager {
    let recipeURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    var delegate: RecipeManagerDelegate?
    
    func getRecipe(id: String) {
        let urlString = recipeURL + id
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                                
                if let safeData = data {
                    if let recipe = self.parseJSON(safeData) {
                        self.delegate?.didUpdateRecipes(self, recipe: recipe)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ recipeData: Data) -> RecipeModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RecipeData.self, from: recipeData)
            
            let curMeal = decodedData.meals[0]
            
            let id = curMeal.idMeal ?? ""
            let mealName = curMeal.strMeal ?? ""
            let category = curMeal.strCategory ?? ""
            let area = curMeal.strArea ?? ""
            let instructions = curMeal.strInstructions ?? ""
            let thumbnail = curMeal.strMealThumb ?? ""
            
            let ingredients: [String] = [curMeal.strIngredient1 ?? "",
                            curMeal.strIngredient2 ?? "",
                            curMeal.strIngredient3 ?? "",
                            curMeal.strIngredient4 ?? "",
                            curMeal.strIngredient5 ?? "",
                            curMeal.strIngredient6 ?? "",
                            curMeal.strIngredient7 ?? "",
                            curMeal.strIngredient8 ?? "",
                            curMeal.strIngredient9 ?? "",
                            curMeal.strIngredient10 ?? "",
                            curMeal.strIngredient11 ?? "",
                            curMeal.strIngredient12 ?? "",
                            curMeal.strIngredient13 ?? "",
                            curMeal.strIngredient14 ?? "",
                            curMeal.strIngredient15 ?? "",
                            curMeal.strIngredient16 ?? "",
                            curMeal.strIngredient17 ?? "",
                            curMeal.strIngredient18 ?? "",
                            curMeal.strIngredient19 ?? "",
                            curMeal.strIngredient20 ?? ""]
            
            let measures: [String] = [curMeal.strMeasure1 ?? "",
                            curMeal.strMeasure2 ?? "",
                            curMeal.strMeasure3 ?? "",
                            curMeal.strMeasure4 ?? "",
                            curMeal.strMeasure5 ?? "",
                            curMeal.strMeasure6 ?? "",
                            curMeal.strMeasure7 ?? "",
                            curMeal.strMeasure8 ?? "",
                            curMeal.strMeasure9 ?? "",
                            curMeal.strMeasure10 ?? "",
                            curMeal.strMeasure11 ?? "",
                            curMeal.strMeasure12 ?? "",
                            curMeal.strMeasure13 ?? "",
                            curMeal.strMeasure14 ?? "",
                            curMeal.strMeasure15 ?? "",
                            curMeal.strMeasure16 ?? "",
                            curMeal.strMeasure17 ?? "",
                            curMeal.strMeasure18 ?? "",
                            curMeal.strMeasure19 ?? "",
                            curMeal.strMeasure20 ?? ""]
            
            let recipe = RecipeModel(idMeal: id,
                                     strMeal: mealName,
                                     strCategory: category,
                                     strArea: area,
                                     strInstructions: instructions,
                                     strMealThumb: thumbnail,
                                     strIngredients: ingredients,
                                     strMeasures: measures)
            
            return recipe
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
