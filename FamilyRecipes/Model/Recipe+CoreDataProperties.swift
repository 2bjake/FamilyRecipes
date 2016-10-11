//
//  Recipe+CoreDataProperties.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/7/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe");
    }

    @NSManaged public var name: String?
    @NSManaged public var sourceString: String?
    @NSManaged public var url: String?

}
