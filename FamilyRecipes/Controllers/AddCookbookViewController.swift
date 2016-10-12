//
//  AddCookbookViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/12/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddCookbookViewController: UIViewController {

    static let doneUnwindIdentifier = "addCookbookDone"
    static let cancelUnwindIdentifier = "addCookbookCancel"

    @IBOutlet weak var nameField: UITextField!

    var name: String? {
        return nameField.text
    }

    func validateForm() -> Bool {
        let isValid = name != nil && !name!.isEmpty
        
        if !isValid {
            let alert = UIAlertController(title: "Add Cookbook", message: "Cookbook name is required", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        return isValid
    }

    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == AddCookbookViewController.doneUnwindIdentifier {
            return validateForm()
        } else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
}
