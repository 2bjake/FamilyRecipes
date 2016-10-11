//
//  AddRecipeDetailViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    }
    
    func isFormValid() -> Bool {
        return false
    }
    
    func updateRecipe(_ recipe: Recipe) {
        return
    }
}
