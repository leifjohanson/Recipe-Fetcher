//
//  RecipeListManager.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 3/1/23.
//

import Foundation


protocol RecipeListManagerDelegate {
    func didUpdateRecipes(_ recipeManager: RecipeListManager, recipeList: [RecipeListModel])
    func didFailWithError(error: Error)
}

struct RecipeListManager {
    let recipeURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    var delegate: RecipeListManagerDelegate?
    
    func getRecipe(category: String) {
        let urlString = recipeURL + category
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
                        self.delegate?.didUpdateRecipes(self, recipeList: recipe)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ recipeListData: Data) -> [RecipeListModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RecipeListData.self, from: recipeListData)
            
            var mealList: [RecipeListModel] = []
            
            for meal in decodedData.meals {
                mealList.append(RecipeListModel(idMeal: meal.idMeal ?? "",
                                                strMeal: meal.strMeal ?? "",
                                                strMealThumb: meal.strMealThumb ?? ""))
            }
            
            
            return mealList
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
