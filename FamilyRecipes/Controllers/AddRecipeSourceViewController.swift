//
//  AddRecipeSourceViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeSourceViewController: UIViewController, UITextFieldDelegate {

    let recipeManager: RecipeManager

    init(recipeManager: RecipeManager) {
        self.recipeManager = recipeManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported as a RecipeManager is required")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    }
    
    func validateForm() -> (isValid: Bool, errorMessage: String?) {
        return (false, nil) //abstract
    }

    @discardableResult func createRecipe(name: String) -> Recipe? {
        return nil //abstract
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
