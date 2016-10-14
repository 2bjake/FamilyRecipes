//
//  AddRecipeSourceViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeSourceViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    }
    
    func validateForm() -> (isValid: Bool, errorMessage: String?) {
        return (false, nil) //abstract
    }
    
    func updateRecipe(_ recipe: Recipe) {
        // abstract
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
