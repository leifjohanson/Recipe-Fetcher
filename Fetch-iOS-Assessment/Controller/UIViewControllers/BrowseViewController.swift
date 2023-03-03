//
//  BrowseViewController.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 3/1/23.
//

import UIKit

class BrowseViewController: UIViewController, RecipeListManagerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var beefCategoryView: UIView!
    @IBOutlet weak var chickenCategoryView: UIView!
    @IBOutlet weak var dessertCategoryView: UIView!
    @IBOutlet weak var lambCategoryView: UIView!
    @IBOutlet weak var miscellaneousCategoryView: UIView!
    @IBOutlet weak var pastaCategoryView: UIView!
    @IBOutlet weak var porkCategoryView: UIView!
    @IBOutlet weak var seafoodCategoryView: UIView!
    @IBOutlet weak var sideCategoryView: UIView!
    @IBOutlet weak var starterCategoryView: UIView!
    @IBOutlet weak var veganCategoryView: UIView!
    @IBOutlet weak var vegetarianCategoryView: UIView!
    @IBOutlet weak var breakfastCategoryView: UIView!
    @IBOutlet weak var goatCategoryView: UIView!
    
    @IBOutlet weak var categoryScrollView: UIScrollView!
    
    @IBOutlet weak var resultStackView: UIStackView!
    
    
    
    // MARK: - Global Variables
    
    var categoryViews: [UIView] = []
    var categoryTaps: [UITapGestureRecognizer] = []
    var recipeListManager = RecipeListManager()
    
    var viewToCategoryTapHashmap: [UIView: UITapGestureRecognizer] = [:]
    let categoryNames = ["Beef", "Chicken", "Dessert", "Lamb", "Miscellaneous", "Pasta", "Pork", "Seafood", "Side", "Starter", "Vegan", "Vegetarian", "Breakfast", "Goat"]
    
    var resultTaps: [UITapGestureRecognizer] = []
    var resultViews: [ResultView] = []
    var recipeList: [RecipeListModel] = []
    
    var selectedID = ""
    
    
    
    // MARK: - ViewDid___() Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Block 1: Disabled the scroll indicator for the Category Scroll View (horizontal) and hides the navigation bar, as there is no practical use in going back to the title screen (title screen is still accessible if the user swipes right)
        navigationController?.navigationBar.isHidden = true
        categoryScrollView.showsHorizontalScrollIndicator = false
        
        // Block 2: Sets the global categoryViews array, enables the UITapGestureRecognizers for the categoryViews, and sets some UI aspects
        categoryViews = [beefCategoryView,
                         chickenCategoryView,
                         dessertCategoryView,
                         lambCategoryView,
                         miscellaneousCategoryView,
                         pastaCategoryView,
                         porkCategoryView,
                         seafoodCategoryView,
                         sideCategoryView,
                         starterCategoryView,
                         veganCategoryView,
                         vegetarianCategoryView,
                         breakfastCategoryView,
                         goatCategoryView]
        enableCategoryTaps()
        categoryViews.disableAllBut(view: beefCategoryView, viewToCategoryTaps: viewToCategoryTapHashmap)
        categoryViews.roundCorners(cornerRadius: beefCategoryView.bounds.height / 2)
        
        // Block 3: Sets the recipeList manager to current file, makes the default category on load the Beef recipes
        recipeListManager.delegate = self
        recipeListManager.getRecipe(category: "Beef")
    }
    
    
    
    // MARK: - RecipeListManagerDelegate Methods
    
    func didUpdateRecipes(_ recipeManager: RecipeListManager, recipeList: [RecipeListModel]) {
        DispatchQueue.main.async {
            // Making sure the stackview is empty before adding new results, as to not append chicken results to the beef results, for example
            for arrangedSubview in self.resultStackView.arrangedSubviews {
                self.resultStackView.removeArrangedSubview(arrangedSubview)
                arrangedSubview.removeFromSuperview()
            }
            
            // Making sure resultTaps and resultViews arrays are empty, as these should only carry the taps/views of the selected category
            self.resultTaps = []
            self.resultViews = []
            
            // Loop through every meal in the recipeList, which is an array of all the JSON meal objects from the API
            for meal in recipeList {
                // Block 1: Creates new custom ResultView (Fetch-iOS-Assessment->View->UIViews->ResultView) with a height of 150.0 and sets the values based on the data from API. The ResultView
                let resultView = ResultView()
                let resultViewHeight = resultView.heightAnchor.constraint(equalToConstant: 150.0)
                resultViewHeight.priority = UILayoutPriority(749.0)
                resultViewHeight.isActive = true
                resultView.configureView(recipeImage: UIImage(systemName: "circles.hexagonpath.fill")!, recipeTitle: meal.strMeal, recipeID: meal.idMeal)
                resultView.recipeImageView.setImageFromWeb(link: meal.strMealThumb)
                
                // Block 2: Creates a UITapGestureRecognizer with handleResultTap() method as action, then binds the tap to the view, adds it to the global resultTaps array, and sets the resultView.tap attribute to the tap.
                let resultTap = UITapGestureRecognizer(target: self, action: #selector(self.handleResultTap(_:)))
                resultView.tap = resultTap
                resultView.addGestureRecognizer(resultTap)
                self.resultTaps.append(resultTap)
                
                // Block 3: ResultView is added to the IBOutlet resultStackView in an arranged matter. The global resultViews array is also updated with the current resultView.
                self.resultStackView.addArrangedSubview(resultView)
                self.resultViews.append(resultView)
            }
        }
    }

    func didFailWithError(error: Error) {
        print(error)
        print(error.localizedDescription)
    }

    
    
    // MARK: - @objc Handle___Tap() Methods
                                         
    // Depending on which category is tapped, the UI is updated to make all but the selected categoryView disabled, and the API is called to fetch meals for that category
    @objc func handleCategoryTap(_ sender: UITapGestureRecognizer) {
        switch sender {
        case categoryTaps[0]:  // Beef
            categoryViews.disableAllBut(view: categoryViews[0], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[0])
        case categoryTaps[1]:  // Chicken
            categoryViews.disableAllBut(view: categoryViews[1], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[1])
        case categoryTaps[2]:  // Dessert
            categoryViews.disableAllBut(view: categoryViews[2], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[2])
        case categoryTaps[3]:  // Lamb
            categoryViews.disableAllBut(view: categoryViews[3], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[3])
        case categoryTaps[4]:  // Miscellaneous
            categoryViews.disableAllBut(view: categoryViews[4], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[4])
        case categoryTaps[5]:  // Pasta
            categoryViews.disableAllBut(view: categoryViews[5], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[5])
        case categoryTaps[6]:  // Pork
            categoryViews.disableAllBut(view: categoryViews[6], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[6])
        case categoryTaps[7]:  // Seafood
            categoryViews.disableAllBut(view: categoryViews[7], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[7])
        case categoryTaps[8]:  // Side
            categoryViews.disableAllBut(view: categoryViews[8], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[8])
        case categoryTaps[9]:  // Starter
            categoryViews.disableAllBut(view: categoryViews[9], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[9])
        case categoryTaps[10]:  // Vegan
            categoryViews.disableAllBut(view: categoryViews[10], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[10])
        case categoryTaps[11]:  // Vegatarian
            categoryViews.disableAllBut(view: categoryViews[11], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[11])
        case categoryTaps[12]:  // Breakfast
            categoryViews.disableAllBut(view: categoryViews[12], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[12])
        case categoryTaps[13]:  // Goat
            categoryViews.disableAllBut(view: categoryViews[13], viewToCategoryTaps: viewToCategoryTapHashmap)
            recipeListManager.getRecipe(category: categoryNames[13])
        default:  // (Should be impossible to reach)
            print("error")
        }
    }
    
    // Handles the UITapGestureRecognizers of all the ResultViews. Once a result has been selected, the segue is performed to show the recipe description
    @objc func handleResultTap(_ sender: UITapGestureRecognizer) {
        var index = 0
        for resultTap in resultTaps {
            if resultTap == sender {
                selectedID = resultViews[index].id
                performSegue(withIdentifier: "resultSelected", sender: self)
                break  // To make runtime slightly faster; prevents the searching through the whole list
            }
            
            index += 1
        }
    }
    
    
    
    // MARK: - EnableCategoryTaps()
    
    // Sets UITapGestureRecognizers to each view
    func enableCategoryTaps() {
        for curView in categoryViews {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleCategoryTap(_:)))
            curView.addGestureRecognizer(tap)
            viewToCategoryTapHashmap[curView] = tap
            categoryTaps.append(tap)
        }
    }
    
    
    
    // MARK: - Segue Preparation
    
    // Passes the ID of the selected result to the RecipeDescriptionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSelected" {
            let rdvc = segue.destination as! RecipeDescriptionViewController
            rdvc.mealID = selectedID
        }
    }

}



// MARK: - Extensions

extension Array where Element == UIView {
    func roundCorners(cornerRadius: CGFloat) {
        for curView in self {
            curView.clipsToBounds = false
            curView.layer.cornerRadius = cornerRadius
        }
    }
    
    // Makes each UIView in the array (self) "turn off (see turnOff())" besides the given UIView (view argument)
    func disableAllBut(view: UIView, viewToCategoryTaps: [UIView : UITapGestureRecognizer]) {
        for curView in self {
            if view == curView {
                curView.turnOn(tap: viewToCategoryTaps[curView]!)
            } else {
                curView.turnOff(tap: viewToCategoryTaps[curView]!)
            }
        }
    }
}

extension UIView {
    // Said UIView "looks disabled" (gray color)
    func turnOn(tap: UITapGestureRecognizer) {
        self.backgroundColor = UIColor(red: 245/255, green: 106/255, blue: 77/255, alpha: 1)
    }
    
    // Said UIView "looks enabled" (orange color)
    func turnOff(tap: UITapGestureRecognizer) {
        self.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
    }
}
