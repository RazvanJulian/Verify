//
//  ToDoList.swift
//  Verify
//
//  Created by Razvan Julian on 16/07/15.
//  Copyright (c) 2015 Razvan Julian. All rights reserved.
//
/*
import Foundation
import UIKit

class TodoList {
    class var sharedInstance : TodoList {
        struct Static {
            static let instance : TodoList = TodoList()
        }
        return Static.instance
    }
    
    
    
    /*
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("todoItems")
    
    
    // MARK: NSCoding
    
    func saveToDoItems() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(todoItems, toFile: ToDoItem.ArchiveURL.path!)
    if !isSuccessfulSave {
    print("Failed to save tasks...")
    }
    }
    
    func loadToDoItems() -> [ToDoItem]? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(ToDoItem.ArchiveURL.path!) as? [ToDoItem]
    }
    
    
    */
    
    
    private let ITEMS_KEY = "todoItems"
    
    func allItems() -> [ToDoItem] {
        let todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map({ToDoItem(deadline: $0["deadline"] as! NSDate, note: $0["note"] as! String,  title: $0["title"] as! String, UUID: $0["UUID"] as! String!)!}).sort({(left: ToDoItem, right:ToDoItem) -> Bool in
            (left.deadline.compare(right.deadline) == .OrderedAscending)
        })
    }
    
    func addItem(item: ToDoItem) {
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary![item.UUID] = ["deadline": item.deadline, "note": item.note, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "You have to \"\(item.title)\" " // text that will be displayed in the notification
        notification.alertAction = "Open the app" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["note":item.note, "title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        self.setBadgeNumbers()
    }
    
    func removeItem(item: ToDoItem) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as[UILocalNotification]! { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
        
        if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
            todoItems.removeValueForKey(item.UUID)
            NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
        
        self.setBadgeNumbers()
    }
    
    func scheduleReminderforItem(item: ToDoItem) {
        let notification = UILocalNotification() // create a new reminder notification
        notification.alertBody = "Reminder: Don't forget to \"\(item.title)\" " // text that will be displayed in the notification
        notification.alertAction = "Open the app" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate().dateByAddingTimeInterval(30 * 60) // 30 minutes from current time
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification that we can use to retrieve it later
        notification.category = "TODO_CATEGORY"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func setBadgeNumbers() {
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]! // all scheduled notifications
        let todoItems: [ToDoItem] = self.allItems()
        
        for notification in notifications {
            let overdueItems = todoItems.filter({ (todoItem) -> Bool in // array of to-do items...
                return (todoItem.deadline.compare(notification.fireDate!) != .OrderedDescending) // ...where item deadline is before or on notification fire date
            })
            
            UIApplication.sharedApplication().cancelLocalNotification(notification) // cancel old notification
            notification.applicationIconBadgeNumber = overdueItems.count // set new badge number
            UIApplication.sharedApplication().scheduleLocalNotification(notification) // reschedule notification
        }
    }
}
*/