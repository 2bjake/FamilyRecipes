//
//  AddRecipeTableViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!

    static let doneUnwindIdentifier = "addRecipeDone"
    static let cancelUnwindIdentifier = "addRecipeCancel"
    
    
    let sourcePickerValues = ["Cookbook", "Website", "Photo", "Text"]
    var embeddedDetailController: UITabBarController?
    var moc: NSManagedObjectContext?

    var sourceIndex = 1 {
        didSet {
            embeddedDetailController?.selectedIndex = sourceIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourcePicker.delegate = self
        sourcePicker.dataSource = self
        sourcePicker.selectRow(sourceIndex, inComponent: 0, animated: false)
    }
    
    private func validateForm() -> Bool{
        if nameTextField.text == nil || nameTextField.text!.characters.count == 0 {
            let alert = UIAlertController(title: "Add Recipe", message: "Recipe name is required", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        } else if let detailVC = detailViewController() {
            return detailVC.validateForm()
        } else {
            return false
        }
    }
    
    private func createRecipe() {
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: moc!) as! Recipe
        recipe.name = nameTextField.text
        detailViewController()!.updateRecipe(recipe)
    }
    
    func detailViewController() -> AddRecipeDetailViewController? {
        return embeddedDetailController?.selectedViewController as? AddRecipeDetailViewController
    }
    
    // MARK: Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == AddRecipeTableViewController.doneUnwindIdentifier {
            return validateForm()
        } else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRecipeDetailEmbed" {
            embeddedDetailController = segue.destination as? UITabBarController
            embeddedDetailController?.selectedIndex = sourceIndex
        } else if segue.identifier == AddRecipeTableViewController.doneUnwindIdentifier {
            if validateForm() {
                createRecipe()
            }
        }
    }
    
    // MARK: UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sourcePickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sourcePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("source \(sourcePickerValues[row]) was selected") //TODO: remove me
        sourceIndex = row
    }

    
}
