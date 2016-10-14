//
//  AppDelegate.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/5/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    let coreDataFile = "FamilyRecipesModel"
    var dataDoc : UIManagedDocument?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window!.rootViewController = WaitViewController()
        window!.makeKeyAndVisible()
        openCoreDataDocument()
        return true
    }
    
    func openCoreDataDocument() {
        let url = coreDataUrl()
        
        if dataDoc == nil {
            dataDoc = UIManagedDocument(fileURL: url)
        }
        
        if FileManager.default.fileExists(atPath: url.path) {
            dataDoc!.open {
                if $0 {
                    self.dataDocReady()
                } else {
                    print("couldn't open the document at \(url)")
                }
            }
        } else {
            dataDoc!.save(to: url, for: .forCreating) {
                if $0 {
                    self.dataDocReady()
                } else {
                    print("coudln't create the document at \(url)")
                }
            }
        }
    }
    
    func coreDataUrl() -> URL {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDirectory.appendingPathComponent(coreDataFile);
    }
    
    func dataDocReady() {
        if dataDoc != nil && dataDoc!.documentState == .normal {
            let recipeManager = RecipeManager(managedDocument: dataDoc!)
            window!.rootViewController = UINavigationController(rootViewController: RecipeTableViewController(recipeManager: recipeManager))
        } else {
            print ("document at \(dataDoc!.fileURL) is not ready")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

