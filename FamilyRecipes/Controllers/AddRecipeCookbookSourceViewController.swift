//
//  AddRecipeCookbookSourceViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/12/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeCookbookSourceViewController: AddRecipeSourceViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let cookbookLabel = UILabel()
    let cookbookTextField = UITextField()
    let cookbookPicker = UIPickerView()
    let addCookbookButton = UIButton(type: .roundedRect)
    let pageNumberLabel = UILabel()
    let pageNumberField = UITextField()

    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            fetchCookbooks()
        }
    }
    var cookbooks = [Cookbook]()

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
        if cookbooks.isEmpty {
            fetchCookbooks()
        }
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
        let request : NSFetchRequest<Cookbook> = Cookbook.fetchRequest()
        request.predicate = nil;
        request.fetchLimit = 50;
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            cookbooks = try managedObjectContext.fetch(request)
            if cookbooks.count == 0 {
                cookbookPicker.isHidden = true
            } else {
                cookbookPicker.isHidden = false
                cookbookPicker.reloadAllComponents()
                var index : Int? = nil
                if let selected = selectedCookbook {
                    index = cookbooks.index(of: selected);
                }
                cookbookPicker.selectRow((index ?? cookbooks.count / 2), inComponent: 0, animated: false)
                updateCookbookTextField()
            }
        } catch {
            fatalError("Failed to fetch cookbooks: \(error)")
        }
    }

    func addCookbookTouched() {
        print("add cookbook touched") //TODO
    }

    private func updateCookbookTextField() {
        let index = cookbookPicker.selectedRow(inComponent: 0)
        cookbookTextField.text = cookbooks[index].name
    }
    
    private func createCookbook(name: String) {
        let cookbook = NSEntityDescription.insertNewObject(forEntityName: "Cookbook", into: managedObjectContext!) as! Cookbook
        cookbook.name = name
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
