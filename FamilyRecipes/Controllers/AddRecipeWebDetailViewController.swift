//
//  AddRecipeWebDetailViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/7/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeWebDetailViewController: AddRecipeDetailViewController, UITextFieldDelegate {
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
    
    override func validateForm() -> Bool {
        if let urlString = urlTextField.text, URL(string:urlString) != nil {
            return true
        } else {
            presentAlertText("Web address must be valid")
            return false
        }
    }
    
    override func updateRecipe(_ recipe: Recipe) {
        recipe.source = .website
        recipe.url = urlTextField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
