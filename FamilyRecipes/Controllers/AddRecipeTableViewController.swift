//
//  AddRecipeTableViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeTableViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    let nameLabel = UILabel()
    let nameTextField = UITextField()
    let sourceLabel = UILabel()
    let sourcePicker = UIPickerView()


    static let doneUnwindIdentifier = "addRecipeDone"
    static let cancelUnwindIdentifier = "addRecipeCancel"
    
    
    let sourcePickerValues = ["Cookbook", "Website", "Photo", "Text"]
    var embeddedDetailController: UITabBarController?
    var managedObjectContext: NSManagedObjectContext! // must be set before presented

    var sourceIndex = 1 {
        didSet {
            setDetailViewControllerIndex()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sourcePicker.delegate = self
        sourcePicker.dataSource = self
        sourcePicker.selectRow(sourceIndex, inComponent: 0, animated: false)
        setupStackView()
    }
/*
    func setupViews() {
        view.backgroundColor = UIColor.white
        let margins = view.layoutMarginsGuide

        let navBar = createNavBar()
        self.view.addSubview(navBar)

        nameLabel.text = "Recipe Name"
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        sourceLabel.text = "Source"
        view.addSubview(sourceLabel)
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8).isActive = true
        sourceLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        sourceLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        view.addSubview(sourcePicker)
        sourcePicker.translatesAutoresizingMaskIntoConstraints = false
        sourcePicker.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8).isActive = true
        sourcePicker.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        sourcePicker.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
*/
    func setupStackView() {
        view.backgroundColor = UIColor.white
        let margins = view.layoutMarginsGuide

        let navBar = createNavBar()
        self.view.addSubview(navBar)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        //stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        nameLabel.text = "Recipe name"
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        sourceLabel.text = "Source"
        stackView.addArrangedSubview(sourceLabel)
        stackView.addArrangedSubview(sourcePicker)

        let elementHeight = nameLabel.frame.height + nameTextField.frame.height + sourceLabel.frame.height + sourcePicker.frame.height
        stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: elementHeight + stackView.spacing * 3)
    }

    func createNavBar() -> UINavigationBar {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 66))
        let navItem = UINavigationItem(title: "Add Recipe")
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddRecipeTableViewController.doneTouched))
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(AddRecipeTableViewController.cancelTouched))
        navBar.pushItem(navItem, animated: false)
        return navBar
    }

    func doneTouched() {
        if validateForm() {
            createRecipe()
            self.dismiss(animated: true, completion: nil)
            // inform presenter that item was added
        }
    }

    func cancelTouched() {
        self.dismiss(animated: true, completion: nil)
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
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: managedObjectContext) as! Recipe
        recipe.name = nameTextField.text
        detailViewController()!.updateRecipe(recipe)
    }
    
    func detailViewController() -> AddRecipeDetailViewController? {
        return embeddedDetailController?.selectedViewController as? AddRecipeDetailViewController
    }
    
    func setDetailViewControllerIndex() {
        embeddedDetailController?.selectedIndex = sourceIndex
        if let cookbookDetailViewController = detailViewController() as? AddRecipeCookbookDetailViewController {
            cookbookDetailViewController.managedObjectContext = managedObjectContext
        }
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
            setDetailViewControllerIndex()
        } else if segue.identifier == AddRecipeTableViewController.doneUnwindIdentifier {
            if validateForm() {
                createRecipe()
            }
        }
    }
    
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        if let tabController = embeddedDetailController {
            return tabController.childViewControllers
        } else {
            return []
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UIPickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
