//
//  AppDelegate.swift
//  Verify
//
//  Created by Razvan Julian on 15/07/15.
//  Copyright (c) 2015 Razvan Julian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    
    
    // MARK: 3D Touch Quick Actions
    
    enum ShortcutType: String {
        case addTask = "Razvan-Julian.Verify.add-new-task"
        //case Red = "reverse.domain.red"
    }
    
        
    static let applicationShortcutUserInfoIconKey = "applicationShortcutUserInfoIconKey"
        
    
        
    @available(iOS 9.0, *)
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
            var handled = false
            //Get type string from shortcutItem
            if let shortcutType = ShortcutType.init(rawValue: shortcutItem.type) {
                
                //Get root navigation viewcontroller and its first controller
                let rootNavigationViewController = window!.rootViewController as? UINavigationController
                let rootViewController = rootNavigationViewController?.viewControllers.first as UIViewController?
                //Pop to root view controller so that approperiete segue can be performed
                rootNavigationViewController?.popToRootViewController(animated: false)
                
                switch shortcutType {
                case .addTask:
                    rootViewController?.performSegue(withIdentifier: addItem, sender: nil)
                    handled = true
                //case.Red:
                    //rootViewController?.performSegueWithIdentifier(toRedSeque, sender: nil)
                    //handled = true
                }
            }
            return handled
        }
        
        
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
            let handledShortCutItem = handleShortCutItem(shortcutItem)
            completionHandler(handledShortCutItem)
        }
        
        
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        
        
        //self.window = UIWindow(frame: UIScreen.main.bounds)
     
        
        //let rootVC: ToDoListTableViewController = ToDoListTableViewController(nibName: nil, bundle: nil)
        //self.window!.rootViewController = rootVC
        
        //self.window!.makeKeyAndVisible()
        
        
        
        var launchedFromShortCut = false
        //Check for ShortCutItem
        
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            launchedFromShortCut = true
            handleShortCutItem(shortcutItem)
           }
        } else {
            // Fallback on earlier versions
        }
        
        //Return false incase application was lanched from shorcut to prevent
        //application(_:performActionForShortcutItem:completionHandler:) from being called
        //return !launchedFromShortCut
        
        
        /*
        // Actions
        var firstAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "FIRST_ACTION"
        firstAction.title = "Share" // "First Action"
        
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        var secondAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "SECOND_ACTION"
        secondAction.title = "Edit" // "Second Action"

        secondAction.activationMode = UIUserNotificationActivationMode.Background
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        
        var thirdAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        thirdAction.identifier = "THIRD_ACTION"
        thirdAction.title = "Third Action"
        
        thirdAction.activationMode = UIUserNotificationActivationMode.Background
        thirdAction.destructive = false
        thirdAction.authenticationRequired = false
        */
        
        // category
        
        //if #available(iOS 8.0, *) {
            let firstCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            firstCategory.identifier = "FIRST_CATEGORY"
            
               
        //let defaultActions:NSArray = [firstAction, secondAction, thirdAction]
        //let minimalActions:NSArray = [firstAction, secondAction]
        
        //firstCategory.setActions(defaultActions as! [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
        //firstCategory.setActions(minimalActions as! [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        // NSSet of all our categories
        
        let categories:NSSet = NSSet(objects: firstCategory)
        
            
        
        let types:UIUserNotificationType = UIUserNotificationType(arrayLiteral: .alert, .badge)
                
        let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: categories as? Set<UIUserNotificationCategory>)
    
    
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound],categories: (NSSet(array: [firstCategory])) as? Set<UIUserNotificationCategory>))
        
        UIApplication.shared.registerUserNotificationSettings(mySettings)
        
        
        //} else {
            // Fallback on earlier versions
        //}
        
        
        
        
        
        /*
        
        // Actions
        var firstAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "FIRST_ACTION"
        firstAction.title = "First Action"
        
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        var secondAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "SECOND_ACTION"
        secondAction.title = "Second Action"
        
        secondAction.activationMode = UIUserNotificationActivationMode.Foreground
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        
        var thirdAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        thirdAction.identifier = "THIRD_ACTION"
        thirdAction.title = "Third Action"
        
        thirdAction.activationMode = UIUserNotificationActivationMode.Background
        thirdAction.destructive = false
        thirdAction.authenticationRequired = false
        
        
        // category
        
        var firstCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "FIRST_CATEGORY"
        
        let defaultActions:NSArray = [firstAction, secondAction, thirdAction]
        let minimalActions:NSArray = [firstAction, secondAction]
        
        firstCategory.setActions(defaultActions as! [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions as! [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        // NSSet of all our categories
        
        let categories:NSSet = NSSet(objects: firstCategory)
        
        
        
        let types:UIUserNotificationType = UIUserNotificationType(arrayLiteral: .Alert, .Badge)
        
        let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories as! Set<UIUserNotificationCategory>)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
        
        
        */
        
        
        
        
        
        // Set navigation bar tint / background colour
        UINavigationBar.appearance().barTintColor = UIColor.darkGray
        
        
        UIToolbar.appearance().barTintColor = UIColor.darkGray
        
        // Set Navigation bar Title colour
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        // Set navigation bar ItemButton tint colour
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        // Set Navigation bar background image
        //let navBgImage:UIImage = UIImage(named: "bg_blog_navbar_reduced.jpg")!
        //UINavigationBar.appearance().setBackgroundImage(navBgImage, forBarMetrics: .Default)
        
        //Set navigation bar Back button tint colour
        UINavigationBar.appearance().tintColor = UIColor.white
        
        //UIApplication.shared.theme_setStatusBarStyle([.lightContent, .default, .lightContent, .lightContent], animated: true)
        
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let isAuth = UserDefaults.standard
        
        if isAuth.value(forKey: "isAuth") as? Bool == false {
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "ToDoTableViewController")
            self.window?.rootViewController = initialViewController
            
        } else {
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "UnlockViewController")
            self.window?.rootViewController = initialViewController
            
        }
        
        
        self.window?.makeKeyAndVisible()
        
        
        
        /*
        
        let completeAction = UIMutableUserNotificationAction()
        completeAction.identifier = "COMPLETE_TODO" // the unique identifier for this action
        completeAction.title = "Complete" // title for the action button
        completeAction.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        completeAction.authenticationRequired = false // don't require unlocking before performing action
        completeAction.destructive = true // display action in red
        
        let remindAction = UIMutableUserNotificationAction()
        remindAction.identifier = "REMIND"
        remindAction.title = "Remind me in 30 minutes"
        remindAction.activationMode = .Background
        remindAction.destructive = false
        
        let todoCategory = UIMutableUserNotificationCategory() // notification categories allow us to create groups of actions that we can associate with a notification
        todoCategory.identifier = "TODO_CATEGORY"
        todoCategory.setActions([remindAction, completeAction], forContext: .Default) // UIUserNotificationActionContext.Default (4 actions max)
        todoCategory.setActions([completeAction, remindAction], forContext: .Minimal) // UIUserNotificationActionContext.Minimal - for when space is limited (2 actions max)
        
        */
       // application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: NSSet(array: [todoCategory]) as Set<NSObject>)) // we're now providing a set containing our category as an argument
        
       // application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil))
        
        //application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound],categories: (NSSet(array: [todoCategory])) as? Set<UIUserNotificationCategory>))
        
        
        
        // Override point for customization after application launch. */
        //return true
        
        
        return !launchedFromShortCut
    }
    
    
    
    
   // func application(application: UIApplication!,handleActionWithIdentifier identifier:String!,forLocalNotification notification:UILocalNotification!,completionHandler: (() -> Void)!){
    
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
    
            /*
            
            if (identifier == "First_Action"){
                
                
                NSNotificationCenter.defaultCenter().postNotificationName("actionOnePressed", object: nil)
                
                
                
                
            }else  if (identifier == "Second_Action"){
                
                NSNotificationCenter.defaultCenter().postNotificationName("actionTwoPressed", object: nil)
                
                
            }
            
            
            completionHandler()
            
            
            */
        
            
    }
    
    

    
    
    
    
    
    
    
    
    /*
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        let item = ToDoItem(deadline: notification.fireDate!, note: notification.userInfo!["note"] as! String!, title: notification.userInfo!["title"] as! String, UUID: notification.userInfo!["UUID"] as! String!)
        switch (identifier!) {
        case "COMPLETE_TODO":
            TodoList.sharedInstance.removeItem(item!)
        case "REMIND":
            TodoList.sharedInstance.scheduleReminderforItem(item!)
        default: // switch statements must be exhaustive - this condition should never be met
            print("Error: unexpected notification action identifier!")
        }
        completionHandler() }// per developer documentation, app will terminate if we fail to call this */
    



/*
func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
    
    if identifier == "editList" {
        NSNotificationCenter.defaultCenter().postNotificationName("modifyListNotification", object: nil)
    }
    else if identifier == "trashAction" {
        NSNotificationCenter.defaultCenter().postNotificationName("deleteListNotification", object: nil)
    }
    
    completionHandler()
}

*/







    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    
       // print(notificationSettings.types.rawValue)
   }




    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
       // NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
        
            // Do something serious in a real app.
           // print("Received Local Notification:")
            //print(notification.alertBody)
            
        }
        
        
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        
        
        /*
        
        
        // fired when user quits the application
        let todoItems: [ToDoItem] = TodoList.sharedInstance.allItems() // retrieve list of all to-do items
        let overdueItems = todoItems.filter({ (todoItem) -> Bool in
            return todoItem.deadline.compare(NSDate()) != .OrderedDescending
        })
        UIApplication.sharedApplication().applicationIconBadgeNumber = overdueItems.count  // set our badge number to number of overdue items
        
        
        
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        */
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        /*
        
        
         NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
        
        */
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
        
        
        
    }

    // MARK: - Core Data stack
/*

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Razvan-Julian.Verify" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Verify", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Verify.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
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
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

*/

}
