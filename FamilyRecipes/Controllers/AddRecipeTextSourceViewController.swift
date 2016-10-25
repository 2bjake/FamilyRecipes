//
//  AddRecipeTextSourceViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/18/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeTextSourceViewController: AddRecipeSourceViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = AddRecipeTextSourceView()
    }

    override func validateForm() -> (isValid: Bool, errorMessage: String?) {
        let sourceView = view as! AddRecipeTextSourceView

        if sourceView.recipeText.characters.count > 0 {
            return (true, nil)
        } else {
            return (false, "Recipe text must be specified")
        }
    }

    override func createRecipe(name: String) -> Recipe? {
        guard validateForm().isValid else {
            return nil
        }

        let sourceView = view as! AddRecipeTextSourceView
        return recipeManager.createTextRecipe(name: name, text: sourceView.recipeText)
    }
}
