//
//  AddRecipeCookbookSourceViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/12/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeCookbookSourceViewController: AddRecipeSourceViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let cookbookLabel = UILabel()
    let cookbookTextField = UITextField()
    let cookbookPicker = UIPickerView()
    let addCookbookButton = UIButton(type: .roundedRect)
    let pageNumberLabel = UILabel()
    let pageNumberField = UITextField()

    var cookbooks = [Cookbook]()

    let recipeManager: RecipeManager

    init(recipeManager: RecipeManager) {
        self.recipeManager = recipeManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported as a RecipeManager is required")
    }

    override func viewDidLoad() {
        cookbookLabel.text = "Cookbook Name"

        cookbookPicker.dataSource = self
        cookbookPicker.delegate = self

        cookbookTextField.inputView = cookbookPicker
        cookbookTextField.borderStyle = .roundedRect
        cookbookTextField.tintColor = UIColor.clear

        addCookbookButton.setTitle("Add Cookbook", for: .normal)
        addCookbookButton.addTarget(self, action: #selector(addCookbookTouched), for: .touchUpInside)

        pageNumberLabel.text = "Page Number"

        pageNumberField.delegate = self
        pageNumberField.borderStyle = .roundedRect
        pageNumberField.keyboardType = .numberPad

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCookbooks()
    }

    func setupViews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        stackView.addArrangedSubview(cookbookLabel)
        stackView.addArrangedSubview(cookbookTextField)
        stackView.addArrangedSubview(addCookbookButton)
        stackView.addArrangedSubview(pageNumberLabel)
        stackView.addArrangedSubview(pageNumberField)

        // add padding to gobble up the rest of the space at the bottom of the stack view
        let padding = UIView()
        padding.setContentHuggingPriority(1, for: .vertical)
        padding.setContentCompressionResistancePriority(1, for: .vertical)
        stackView.addArrangedSubview(padding)
    }
    
    func fetchCookbooks(withSelected selectedCookbook: Cookbook? = nil) {
        cookbooks = recipeManager.getCookbooks()
        if cookbooks.count == 0 {
            cookbookPicker.isHidden = true
        } else {
            cookbookPicker.isHidden = false
            cookbookPicker.reloadAllComponents()
            var index : Int? = nil
            if let selected = selectedCookbook {
                index = cookbooks.index(of: selected)
            }
            cookbookPicker.selectRow((index ?? cookbooks.count / 2), inComponent: 0, animated: false)
            updateCookbookTextField()
        }
    }

    func addCookbookTouched() {
        let input = UIAlertController(title: "Create Cookbook", message: "Name", preferredStyle: .alert)
        input.addTextField(configurationHandler: nil)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        input.addAction(cancelAction)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let name = input.textFields?.first?.text {
                self.createCookbook(name: name)
            }
        }
        input.addAction(okAction)

        present(input, animated: true, completion: nil)
    }

    private func updateCookbookTextField() {
        let index = cookbookPicker.selectedRow(inComponent: 0)
        cookbookTextField.text = cookbooks[index].name
    }
    
    private func createCookbook(name: String) {
        let cookbook = recipeManager.createCookbook(name: name)
        fetchCookbooks(withSelected: cookbook)
    }

    override func validateForm() -> (Bool, String?) {
        if cookbooks.isEmpty {
            return (false, "Cookbook name required")
        } else if let pageNum = pageNumberField.text, pageNum.isEmpty {
            return (false, "Page number required")
        }
        return (true, nil)
    }
    
    override func updateRecipe(_ recipe: Recipe) {
        recipe.source = .cookbook
        recipe.inBook = cookbooks[cookbookPicker.selectedRow(inComponent: 0)]
        recipe.pageNumber = pageNumberField.text
    }
    
    // MARK: UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cookbooks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cookbooks[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("cookbook \(cookbooks[row].name) was selected") //TODO: remove me
        updateCookbookTextField()
        view.endEditing(true)
    }
    
    // MARK: Navigation
    /*
    func addCookbookUnwind(_ sender: UIStoryboardSegue) {
        if sender.identifier == AddCookbookViewController.doneUnwindIdentifier {
            if let modalViewController = sender.source as? AddCookbookViewController {
                if modalViewController.name == nil || modalViewController.name!.isEmpty {
                    fatalError("Cookbook name is nil or empty")
                }
                createCookbook(name: modalViewController.name!)
            }
        }
    }
 */
}
