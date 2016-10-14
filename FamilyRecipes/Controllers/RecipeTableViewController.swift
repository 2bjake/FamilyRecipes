//
//  RecipeTableViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/5/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setContent(forRecipe recipe: Recipe) {
        textLabel?.text = recipe.name
        if recipe.source == .cookbook {
            detailTextLabel?.text = "\(recipe.inBook?.name ?? "") - page \(recipe.pageNumber ?? "")"
        } else if recipe.source == .website {
            detailTextLabel?.text = recipe.url
        }
    }
}

class RecipeTableViewController : CoreDataTableViewController {

    let cellReuseIdentifier = "recipeCell"
    let recipeManager: RecipeManager

    init(recipeManager: RecipeManager) {
        self.recipeManager = recipeManager

        super.init(nibName: nil, bundle: nil)
        fetchedResultsController = recipeManager.getRecipesFetchedRequestController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported as a RecipeManager is required")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RecipeCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(RecipeTableViewController.addRecipeTouched))
    }

    func addRecipeTouched() {
        let modalVC = AddRecipeViewController(recipeManager: recipeManager)
        self.present(modalVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! RecipeCell
        let recipe = fetchedResultsController?.object(at: indexPath) as! Recipe
        cell.setContent(forRecipe:recipe)
        return cell
    }
}
