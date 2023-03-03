//
//  RecipeDescriptionViewController.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 2/25/23.
//

import UIKit

class RecipeDescriptionViewController: UIViewController, RecipeManagerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var imageGradientView: GradientView!
    
    @IBOutlet weak var ingredientsInstructionsControl: UISegmentedControl!
    
    @IBOutlet weak var dataStack: UIStackView!
    
    
    
    // MARK: - Global Variables
    
    var recipeManager = RecipeManager()
    
    var instructions = [""]
    var ingredients = [[""]]
    
    var dataStackItems: [UIView] = []
    
    // This is set after the transition from BrowseViewController.swift (see its prepare() method)
    var mealID = ""
    
    
    
    // MARK: - ViewDid___() Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageGradientView.roundBottomCorners(cornerRadius: 40)
        recipeImageView.roundBottomCorners(cornerRadius: 40)
        recipeManager.delegate = self
        recipeManager.getRecipe(id: mealID)
    }

    
    
    // MARK: - RecipeManagerDelegate Methods
    
    func didUpdateRecipes(_ recipeManager: RecipeManager, recipe: RecipeModel) {
        DispatchQueue.main.async {
            self.instructions = recipe.getInstructions()
            self.ingredients = recipe.getIngredients()
            self.configureStack()
            self.showIngredients()
            self.recipeImageView.setImageFromWeb(link: recipe.strMealThumb)
            self.recipeTitleLabel.text = recipe.strMeal
        }
    }

    func didFailWithError(error: Error) {
        print(error)
        print("Simply put: \(error.localizedDescription)")
    }

    
    
    // MARK: - IBActions
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:  // Ingredients segment
            showIngredients()
        case 1:  // Instructions segment
            showInstructions()
        default:  // (Should be unreachable)
            print("Error with segmented control")
            showIngredients()
        }
    }
    
    
    
    // MARK: - Functionality
    
    func configureStack() {
        // Gets all the ingredients (2d array of strings, ingredients[x][0] is the ingredient x name, ingredients[x][1] is x measurement) and sets them to IngredientView (a custom UIView, see Fetch-iOS-Assessment->View->UIViews->IngredientView)
        let numberIngredients = ingredients.count
        for i in 1...numberIngredients {
            let ingredientView = IngredientView()
            let ingredientViewHeight = ingredientView.heightAnchor.constraint(equalToConstant: 75.0)
            ingredientViewHeight.priority = UILayoutPriority(749.0)
            ingredientViewHeight.isActive = true
            ingredientView.configureView(ingredient: ingredients[i - 1][0], quantity: ingredients[i - 1][1])
            dataStack.addArrangedSubview(ingredientView)
            dataStackItems.append(ingredientView)
        }
        
        // Gets all the instructions (array of strings) and sets them to InstructionView (a custom UIView, see Fetch-iOS-Assessment->View->UIViews->InstructionView
        let numberInstructions = instructions.count
        for i in 1...numberInstructions {
            let instructionView = InstructionView()
            let instructionViewHeight = instructionView.heightAnchor.constraint(equalToConstant: 75.0)
            instructionViewHeight.priority = UILayoutPriority(749.0)
            instructionViewHeight.isActive = true
            instructionView.configureView(instruction: instructions[i - 1], stepNumber: String(i))
            dataStack.addArrangedSubview(instructionView)
            dataStackItems.append(instructionView)
        }
    }
    
    // Goes through dataStackItems (array of UIViews) and shows the instructions and hides the ingredients
    func showIngredients() {
        for item in dataStackItems {
            if item is InstructionView {
                item.isHidden = true
            } else if item is IngredientView {
                item.isHidden = false
            } else {  // unreachable, but for safety
                print("Error in showIngredients()")
            }
        }
    }
    
    // Goes through dataStackItems (array of UIViews) and shows the instructions and hides the ingredients
    func showInstructions() {
        for item in dataStackItems {
            if item is IngredientView {
                item.isHidden = true
            } else if item is InstructionView {
                item.isHidden = false
            } else {  // unreachable, but for safety
                print("Error in showIngredients()")
            }
        }
    }
}



// MARK: - Extensions

extension UIImageView {
    // A function that pulls an image from the Internet, given the image URL as input (link)
    func setImageFromWeb(link: String) {
        let url = URL(string: link)!
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
                        
            guard let data = data else {
                print("Error: Could not get image")
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("Error: Unable to create image from data")
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
            }
            
        }
        task.resume()
        self.contentMode = .scaleAspectFill
    }
    
    
}

extension UIView {
    // A UI function that sets the given views layer.cornerRadius to the argument cornerRadius, but only the bottom two corners
    func roundBottomCorners(cornerRadius: Int) {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}



// MARK: - GradientView Class

class GradientView: UIView {
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
    }
}

