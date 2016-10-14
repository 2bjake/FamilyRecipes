//
//  AddRecipeWebDetailViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/7/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeWebDetailViewController: AddRecipeDetailViewController {
    let urlTextField = UITextField()
    let webView = UIWebView()

    @IBAction func previewClicked(_ sender: UIButton) {
        if let urlString = urlTextField.text {
            if let url = URL(string: urlString) {
                let request = URLRequest(url:url)
                webView.loadRequest(request)
            }
        }
    }
    
    override func validateForm() -> (Bool, String?) {
        if let urlString = urlTextField.text, URL(string:urlString) != nil {
            return (true, nil)
        } else {
            return (false, "Web address must be valid")
        }
    }
    
    override func updateRecipe(_ recipe: Recipe) {
        recipe.source = .website
        recipe.url = urlTextField.text
    }
}
