//
//  AddRecipeTableViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//
/*
import UIKit
import CoreData

class AddRecipeTableViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    let nameLabel = UILabel()
    let nameTextField = UITextField()
    let sourceLabel = UILabel()
    let sourceTextField = UITextField()
    let sourcePicker = UIPickerView()


    //TODO: remove these
    static let doneUnwindIdentifier = "addRecipeDone"
    static let cancelUnwindIdentifier = "addRecipeCancel"
    
    
    let sourcePickerValues = ["Cookbook", "Website", "Photo", "Text"] // these should come from the enum
    var embeddedDetailController = UITabBarController()
    var managedObjectContext: NSManagedObjectContext! // must be set before presented

    var sourceIndex = 1 {
        didSet {
            setSourceViewComponents()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sourcePicker.delegate = self
        sourcePicker.dataSource = self
        sourcePicker.selectRow(sourceIndex, inComponent: 0, animated: false)

        nameLabel.text = "Recipe name"
        nameTextField.delegate = self
        nameTextField.borderStyle = .roundedRect
        sourceLabel.text = "Source"

        sourceTextField.inputView = sourcePicker
        sourceTextField.borderStyle = .roundedRect
        sourceTextField.tintColor = UIColor.clear

        setupViews()
    }

    func setupViews() {
        view.backgroundColor = UIColor.white

        let navBar = createNavBar()
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 65).isActive = true

        let margins = view.layoutMarginsGuide

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(sourceLabel)
        stackView.addArrangedSubview(sourceTextField)

        let elementHeight = nameLabel.frame.height + nameTextField.frame.height + sourceLabel.frame.height + sourceTextField.frame.height
        stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: elementHeight + stackView.spacing * 3)

        setupDetailView(below: stackView)
    }

    func createNavBar() -> UINavigationBar {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem(title: "Add Recipe")
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddRecipeTableViewController.doneTouched))
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AddRecipeTableViewController.cancelTouched))
        navBar.pushItem(navItem, animated: false)
        return navBar
    }

    func setupDetailView(below: UIView) {
        let cookbookVC = AddRecipeCookbookDetailViewController()
        cookbookVC.managedObjectContext = managedObjectContext
        let websiteVC = AddRecipeWebDetailViewController()
        let photoVC = AddRecipeDetailViewController()
        let textVC = AddRecipeDetailViewController()
        embeddedDetailController.viewControllers = [cookbookVC, websiteVC, photoVC, textVC]
        setSourceViewComponents()

        addChildViewController(embeddedDetailController)
        view.addSubview(embeddedDetailController.view)
        embeddedDetailController.view.translatesAutoresizingMaskIntoConstraints = false
        embeddedDetailController.view.topAnchor.constraint(equalTo: below.bottomAnchor, constant: 8).isActive = true
        embeddedDetailController.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        embeddedDetailController.view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        embeddedDetailController.view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

        embeddedDetailController.didMove(toParentViewController: self)
    }

    func doneTouched() {
        if validateForm() {
            createRecipe()
            dismiss(animated: true, completion: nil)
            //TODO: inform presenter that item was added
        }
    }

    func cancelTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    private func validateForm() -> Bool{
        if nameTextField.text == nil || nameTextField.text!.characters.count == 0 {
            let alert = UIAlertController(title: "Add Recipe", message: "Recipe name is required", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
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
        return embeddedDetailController.selectedViewController as? AddRecipeDetailViewController
    }

    func setSourceViewComponents() {
        embeddedDetailController.selectedIndex = sourceIndex
        sourceTextField.text = sourcePickerValues[sourceIndex]
    }

    //TODO: replace these
    /*
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
 */
    
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
        view.endEditing(true)
    }

    
}
 */
