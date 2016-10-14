//
//  AddRecipeViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeViewController: UIViewController, AddRecipeViewDelegate {

    var recipeSourceController = UITabBarController()
    var managedObjectContext: NSManagedObjectContext! // must be set before presented

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
        let cookbookVC = AddRecipeCookbookDetailViewController()
        cookbookVC.managedObjectContext = managedObjectContext
        let websiteVC = AddRecipeWebDetailViewController()
        let photoVC = AddRecipeDetailViewController()
        let textVC = AddRecipeDetailViewController()
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
        if addRecipeView.nameTextField.text == nil || addRecipeView.nameTextField.text!.characters.count == 0 {
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
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: managedObjectContext) as! Recipe
        let addRecipeView = view as! AddRecipeView
        recipe.name = addRecipeView.nameTextField.text
        selectedRecipeSourceController().updateRecipe(recipe)
    }
    
    func selectedRecipeSourceController() -> AddRecipeDetailViewController {
        return recipeSourceController.selectedViewController as! AddRecipeDetailViewController
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
