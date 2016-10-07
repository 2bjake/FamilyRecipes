//
//  RecipeTableViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/5/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit
import CoreData

class RecipeTableViewController : CoreDataTableViewController, AddRecipeTableViewControllerDelegate {
    
    var moc : NSManagedObjectContext? {
        didSet {
            let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
            request.predicate = nil;
            request.fetchLimit = 50;
            request.sortDescriptors = []
            ///request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photographerCount" ascending:NO],
            fetchedResultsController = (NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>)
        }
    } 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(forName: .mocReady, object: nil, queue: nil) {
            if let info = $0.userInfo as? [String : NSManagedObjectContext] {
                self.moc = info["context"]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let recipe = fetchedResultsController?.object(at: indexPath) as! Recipe
        
        cell.textLabel?.text = recipe.name
        cell.detailTextLabel?.text = ""
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddRecipe" && segue.destination is UINavigationController {
            let nav = segue.destination as! UINavigationController
            if let dest = nav.childViewControllers.first as? AddRecipeTableViewController {
                dest.delegate = self
                dest.moc = moc
            }
        }
    }
    
    // MARK: - AddRecipeTableViewControllerDelegate
    func addRecipeTableViewControllerDidSave(_ controller: AddRecipeTableViewController) {
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func addRecipeTableViewControllerDidCancel(_ controller: AddRecipeTableViewController) {
        dismiss(animated: true, completion: nil)
    }
}
