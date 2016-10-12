//
//  AddRecipeDetailViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeDetailViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    }
    
    func validateForm() -> Bool {
        return false
    }
    
    func updateRecipe(_ recipe: Recipe) {
        return
    }
    
    func presentAlertText(_ text: String) {
        let alert = UIAlertController(title: "Add Recipe", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
