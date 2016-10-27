//
//  AddRecipeCookbookSourceViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/12/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeCookbookSourceViewController: AddRecipeSourceViewController, AddRecipeCookbookSourceViewDelegate {
    var cookbooks = [Cookbook]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let cookbookSourceView = AddRecipeCookbookSourceView()
        cookbookSourceView.delegate = self
        self.view = cookbookSourceView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cookbooks = recipeManager.getCookbooks()
        let sourceView = view as! AddRecipeCookbookSourceView
        sourceView.cookbooksUpdated()
    }

    override func validateForm() -> (isValid: Bool, errorMessage: String?) {
        let sourceView = view as! AddRecipeCookbookSourceView
        if sourceView.cookbook == nil {
            return (false, "Cookbook name required")
        } else if sourceView.pageNumber.isEmpty {
            return (false, "Page number required")
        }
        return (true, nil)
    }
    
    override func createRecipe(name: String) -> Recipe? {

        guard validateForm().isValid else {
            return nil
        }

        let sourceView = view as! AddRecipeCookbookSourceView
        return recipeManager.createCookbookRecipe(name: name, cookbook: sourceView.cookbook!, pageNumber: sourceView.pageNumber)
    }

    // MARK: - AddRecipeCookbookSourceViewDelegate

    func addCookbookTouched(addCompletion: @escaping (Cookbook) -> Void) {
        let input = UIAlertController(title: "Add Cookbook", message: "Name", preferredStyle: .alert)
        input.addTextField(configurationHandler: nil)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        input.addAction(cancelAction)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let name = input.textFields?.first?.text {
                let cookbook = self.recipeManager.createCookbook(name: name)
                self.cookbooks = self.recipeManager.getCookbooks()
                addCompletion(cookbook)
            }
        }
        input.addAction(okAction)

        present(input, animated: true, completion: nil)
    }

    func cookbookValues() -> [Cookbook] {
        return cookbooks
    }
}
