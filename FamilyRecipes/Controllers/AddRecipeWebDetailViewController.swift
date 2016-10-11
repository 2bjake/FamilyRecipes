//
//  AddRecipeWebDetailViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/7/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeWebDetailViewController: AddRecipeDetailViewController {
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func previewClicked(_ sender: UIButton) {
        if let urlString = urlTextField.text {
            if let url = URL(string: urlString) {
                let request = URLRequest(url:url)
                webView.loadRequest(request)
            }
        }
    }
    
    override func isFormValid() -> Bool {
         var isValid = false
        if let urlString = urlTextField.text {
            isValid = URL(string:urlString) != nil
        }
        return isValid
    }
    
    override func updateRecipe(_ recipe: Recipe) {
        if isFormValid() {
            recipe.source = .website
            recipe.url = urlTextField.text
        }
    }
}
