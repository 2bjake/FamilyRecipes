//
//  RecipeTableViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/5/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit
import CoreData

class RecipeCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class RecipeTableViewController : CoreDataTableViewController {

    let cellReuseIdentifier = "recipeCell"
    
    var managedObjectContext : NSManagedObjectContext! {
        didSet {
            let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
            request.predicate = nil;
            request.fetchLimit = 50;
            request.sortDescriptors = []
            ///request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photographerCount" ascending:NO],
            fetchedResultsController = (NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>)
        }
    } 

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RecipeCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(RecipeTableViewController.addRecipeTouched))
    }

    func addRecipeTouched() {
        let modalVC = AddRecipeTableViewController()
        modalVC.managedObjectContext = managedObjectContext
        self.present(modalVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let recipe = fetchedResultsController?.object(at: indexPath) as! Recipe
        
        cell.textLabel?.text = recipe.name
        if recipe.source == .cookbook {
            cell.detailTextLabel?.text = "\(recipe.inBook?.name ?? "") - page \(recipe.pageNumber ?? "")"
        } else if recipe.source == .website {
            cell.detailTextLabel?.text = recipe.url
        }
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddRecipe" && segue.destination is UINavigationController {
            let nav = segue.destination as! UINavigationController
            if let dest = nav.childViewControllers.first as? AddRecipeTableViewController {
                dest.managedObjectContext = managedObjectContext
            }
        }
    }
    
    @IBAction func addRecipeUnwind(_ sender: UIStoryboardSegue) {
        if sender.identifier == AddRecipeTableViewController.doneUnwindIdentifier {
            tableView.reloadData()
        }
    }
}
