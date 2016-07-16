//
//  AppDelegate.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 01/10/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        // ----- iOS Version -----
        func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: NSString) -> Bool {
            return UIDevice.currentDevice().systemVersion.compare(version as String,
                options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
        }
        
        // ----- STYLE ------
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = uicolorFromHex(0xffffff)
        navigationBarAppearace.barTintColor = uicolorFromHex(0x020202)
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        /* ---------------------------------------------------- */
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8"){
            // Actions
            let firstAction :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            firstAction.identifier = "FIRST_ACTION"
            firstAction.title = NSLocalizedString("No", comment: "No")
            firstAction.destructive = true
            firstAction.authenticationRequired = false
            firstAction.activationMode = UIUserNotificationActivationMode.Background
            
            let secondAction :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            secondAction.identifier = "SECOND_ACTION"
            secondAction.title = NSLocalizedString("Note", comment: "Note")
            secondAction.destructive = false
            secondAction.authenticationRequired = false
            secondAction.activationMode = UIUserNotificationActivationMode.Foreground
            
            // Category
            let firstCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            firstCategory.identifier = "CATEGORY"
            firstCategory.setActions([firstAction,secondAction], forContext: UIUserNotificationActionContext.Default)
            firstCategory.setActions([firstAction,secondAction], forContext: UIUserNotificationActionContext.Minimal)
            
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType([.Sound, .Alert, .Badge]), categories: (NSSet(array: [firstCategory])) as? Set<UIUserNotificationCategory>))
            
        }
        
        return true
    }
    
    func application(application: UIApplication,
        handleActionWithIdentifier identifier:String?,
        forLocalNotification notification:UILocalNotification,
        completionHandler: (() -> Void)){
            
            if (identifier == "FIRST_ACTION") {
                NSNotificationCenter.defaultCenter().postNotificationName("actionNoPressed", object: nil)
            } else if (identifier == "SECOND_ACTION") {
                NSNotificationCenter.defaultCenter().postNotificationName("actionNotePressed", object: nil)
            }
            completionHandler()
    }
    
    //Define colors in hex values
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0x0000FF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //println(UIApplication.sharedApplication().scheduledLocalNotifications)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //println(UIApplication.sharedApplication().scheduledLocalNotifications)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "br.com.BazaInc.DreamNotes" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DreamNotes", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("DreamNotes.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil )
        } catch {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            print("deu merda: \(error)")
            //dict[NSUnderlyingErrorKey] = error
            
            //error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            let error: NSError? = nil
            if moc.hasChanges {//&& !moc.save(&error)
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

