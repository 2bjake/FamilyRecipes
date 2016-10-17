//
//  AddRecipeViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, AddRecipeViewDelegate {

    var recipeSourceController = UITabBarController()
    let recipeManager: RecipeManager

    init(recipeManager: RecipeManager) {
        self.recipeManager = recipeManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported as RecipeManager is required")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let addRecipeView = AddRecipeView()
        view = addRecipeView

        addRecipeView.delegate = self

        setupRecipeSourceViewController()
        addChildViewController(recipeSourceController)
        addRecipeView.setRecipeSourceView(recipeSourceController.view)
        recipeSourceController.didMove(toParentViewController: self)
    }

    func setupRecipeSourceViewController() {
        //TODO: the order of these has to match the order of the source values passed to the view (lame). fix this
        let cookbookVC = AddRecipeCookbookSourceViewController(recipeManager: recipeManager)
        let websiteVC = AddRecipeWebSourceViewController()
        let photoVC = AddRecipeSourceViewController()
        let textVC = AddRecipeSourceViewController()
        recipeSourceController.viewControllers = [cookbookVC, websiteVC, photoVC, textVC]
    }

    private func presentValidationAlert(_ message: String?) {
        let msg = message ?? "A required field has not been set"
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func validateForm() -> Bool{
        let addRecipeView = view as! AddRecipeView
        if addRecipeView.recipeName.characters.count == 0 {
            presentValidationAlert("Recipe name is required")
            return false
        } else {
            let result = selectedRecipeSourceController().validateForm()
            if !result.isValid {
                presentValidationAlert(result.errorMessage)
            }
            return result.isValid
        }
    }
    
    private func createRecipe() {
        let addRecipeView = view as! AddRecipeView
        if addRecipeView.recipeName.characters.count > 0 {
            let recipe = recipeManager.createRecipe(name: addRecipeView.recipeName)
            selectedRecipeSourceController().updateRecipe(recipe)
        } else {
            presentValidationAlert("Recipe name is required")
        }
    }
    
    func selectedRecipeSourceController() -> AddRecipeSourceViewController {
        return recipeSourceController.selectedViewController as! AddRecipeSourceViewController
    }

    // MARK: - AddRecipeViewDelegate

    func addRecipeDone() {
        if validateForm() {
            createRecipe()
            dismiss(animated: true, completion: nil)
            //TODO: inform presenter that item was added
        }
    }

    func addRecipeCancel() {
        dismiss(animated: true, completion: nil)
    }

    func recipeSourceValues() -> [String] {
        return ["Cookbook", "Website", "Photo", "Text"] //TODO: these should come from the model
    }

    func recipeSourceIndexChanged(_ newIndex: Int) {
        recipeSourceController.selectedIndex = newIndex
    }
}
