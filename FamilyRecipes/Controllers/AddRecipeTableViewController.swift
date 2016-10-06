//
//  AddRecipeTableViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/6/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit
import CoreData

protocol AddRecipeTableViewControllerDelegate {
    func addRecipeTableViewControllerDidCancel(_ controller:AddRecipeTableViewController) -> Void;
    func addRecipeTableViewControllerDidSave(_ controller:AddRecipeTableViewController) -> Void;
}

class AddRecipeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var sourcePicker: UIPickerView!

    let sourcePickerValues = ["Cookbook", "Website", "Photo", "Text"]
    var embeddedDetailController: UITabBarController?
    var moc: NSManagedObjectContext?
    var delegate : AddRecipeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourcePicker.delegate = self
        sourcePicker.dataSource = self
    }
    
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
        embeddedDetailController?.selectedIndex = row
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        delegate?.addRecipeTableViewControllerDidCancel(self)
    }

    @IBAction func done(_ sender: UIBarButtonItem) {
        /*
        if let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: context) as? Recipe {
            
        }
 */
        delegate?.addRecipeTableViewControllerDidSave(self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRecipeDetailEmbed" {
            embeddedDetailController = segue.destination as? UITabBarController
        }
    }
}
