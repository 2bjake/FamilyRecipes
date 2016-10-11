//
//  Recipe+CoreDataClass.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/5/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import Foundation
import CoreData

public class Recipe: NSManagedObject {
    
    enum Source : String { case cookbook, website, photo, text}
    
    var source : Source {
        get {
            return Source(rawValue: sourceString!)!
        }
        set {
            sourceString = newValue.rawValue
        }
    }

}
