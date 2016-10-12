//
//  AddRecipeCookbookDetailViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/12/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeCookbookDetailViewController: AddRecipeDetailViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pageNumberField: UITextField!
    @IBOutlet weak var cookbookPicker: UIPickerView!
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            fetchCookbooks()
        }
    }
    var cookbooks = [Cookbook]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cookbooks.isEmpty {
            fetchCookbooks()
        }
    }
    
    func fetchCookbooks(withSelected selectedCookbook: Cookbook? = nil) {
        if let moc = managedObjectContext {
            let request : NSFetchRequest<Cookbook> = Cookbook.fetchRequest()
            request.predicate = nil;
            request.fetchLimit = 50;
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            do {
                cookbooks = try moc.fetch(request)
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
                }
            } catch {
                fatalError("Failed to fetch cookbooks: \(error)")
            }
        }
    }
    
    private func createCookbook(name: String) {
        let cookbook = NSEntityDescription.insertNewObject(forEntityName: "Cookbook", into: managedObjectContext!) as! Cookbook
        cookbook.name = name
        fetchCookbooks(withSelected: cookbook)
    }

    override func validateForm() -> Bool {
        if cookbooks.isEmpty {
            presentAlertText("Cookbook name required")
            return false
        } else if let pageNum = pageNumberField.text, pageNum.isEmpty {
            presentAlertText("Page number required")
            return false
        }
        return true
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
        //TODO: do i need track selection? probably not...
    }
    
    // MARK: Navigation
    
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
}
