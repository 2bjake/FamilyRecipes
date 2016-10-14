//
//  RecipeManager.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/14/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecipeManager {
    let managedDocument: UIManagedDocument

    init(managedDocument: UIManagedDocument) {
        self.managedDocument = managedDocument
    }

    func getRecipesFetchedRequestController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = nil
        request.fetchLimit = 50 //TODO: take this as a param?
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        return (NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedDocument.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>)
    }

    func getCookbooks() -> [Cookbook] {
        let request : NSFetchRequest<Cookbook> = Cookbook.fetchRequest()
        request.predicate = nil
        request.fetchLimit = 50 //TODO: take this as a param?
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let cookbooks = try? managedDocument.managedObjectContext.fetch(request)
        return cookbooks ?? []
    }

    func createRecipe(name: String) -> Recipe {
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: managedDocument.managedObjectContext) as! Recipe
        recipe.name = name
        return recipe
    }

    func createCookbook(name: String) -> Cookbook {
        //TODO: ensure that cookbook doesn't already exist
        let cookbook = NSEntityDescription.insertNewObject(forEntityName: "Cookbook", into: managedDocument.managedObjectContext) as! Cookbook
        cookbook.name = name
        return cookbook
    }
}
