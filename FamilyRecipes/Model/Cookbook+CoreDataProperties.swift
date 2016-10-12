//
//  Cookbook+CoreDataProperties.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/12/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import Foundation
import CoreData

extension Cookbook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cookbook> {
        return NSFetchRequest<Cookbook>(entityName: "Cookbook");
    }

    @NSManaged public var name: String?
    @NSManaged public var hasRecipe: NSSet?

}

// MARK: Generated accessors for hasRecipe
extension Cookbook {

    @objc(addHasRecipeObject:)
    @NSManaged public func addToHasRecipe(_ value: Recipe)

    @objc(removeHasRecipeObject:)
    @NSManaged public func removeFromHasRecipe(_ value: Recipe)

    @objc(addHasRecipe:)
    @NSManaged public func addToHasRecipe(_ values: NSSet)

    @objc(removeHasRecipe:)
    @NSManaged public func removeFromHasRecipe(_ values: NSSet)

}
