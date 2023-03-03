//
//  MealAPI.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 2/28/23.
//

import Foundation

class MealAPI {
    static func fetchMeal(withId id: String, completion: @escaping (Result<RecipeData, Error>) -> Void) {
        let urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Invalid data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(RecipeData.self, from: data)
                // completion(.success(result))
                print(result.meals)
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
