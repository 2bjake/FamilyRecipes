//
//  AddRecipeWebSourceViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/7/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeWebSourceViewController: AddRecipeSourceViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = AddRecipeWebSourceView()
    }

    /*
    @IBAction func previewClicked(_ sender: UIButton) {
        if let urlString = urlTextField.text {
            if let url = URL(string: urlString) {
                let request = URLRequest(url:url)
                webView.loadRequest(request)
            }
        }
    }
 */
    
    override func validateForm() -> (isValid: Bool, errorMessage: String?) {
        let sourceView = view as! AddRecipeWebSourceView

        if URL(string: sourceView.urlString) != nil {
            return (true, nil)
        } else {
            return (false, "Web address must be valid")
        }
    }
    
    override func createRecipe(name: String) -> Recipe? {
        guard validateForm().isValid else {
            return nil
        }

        let sourceView = view as! AddRecipeWebSourceView
        return recipeManager.createWebsiteRecipe(name: name, urlString: sourceView.urlString)
    }
}
