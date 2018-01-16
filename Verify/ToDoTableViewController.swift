//
//  ToDoTableViewController.swift
//  Verify
//
//  Created by Razvan Julian on 15/07/15.
//  Copyright (c) 2015 Razvan Julian. All rights reserved.
//

import UIKit
import Foundation
import GoogleMobileAds
import Social
import MessageUI
import LocalAuthentication

let addItem = "AddItem"
let showDetail = "ShowDetail"

class ToDoTableViewController: UITableViewController, GADBannerViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    var textField: UITextField!
    
    
    
    
    
    
    
        
    @IBAction func twitterAction(_ sender: Any) {
        
        
        
        
        let alertController = UIAlertController(title: nil, message: "Share", preferredStyle: .actionSheet)
        
        let twitterAction = UIAlertAction(title: "Twitter", style: .default) { (alert) in
            
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                
                let twitter:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                twitter.setInitialText("I've just completed all my #tasks with Verify! Now #available #free on the #AppStore by @RazvanJulianDev! https://itunes.apple.com/us/app/verify-simple-intuitive-human/id1029172853?ls=1&mt=8")
                
                self.present(twitter, animated: true, completion: nil)
                
                
            } else {
                
                let alert = UIAlertController(title: "Accounts", message: "Please log into your Twitter account within the Settings!", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        
        
        let messageAction = UIAlertAction(title: "Message", style: .default) { (alert) in
            
            if MFMessageComposeViewController.canSendText() {
                
                let message:MFMessageComposeViewController = MFMessageComposeViewController()
                
                message.messageComposeDelegate = self
                
                message.recipients = nil
                message.subject = "Meet Verify!"
                message.body = "Now #available #free on the #AppStore by @RazvanJulianDev! https://itunes.apple.com/us/app/verify-simple-intuitive-human/id1029172853?ls=1&mt=8"
                
                self.present(message, animated: true, completion: nil)
                
                
            } else {
                
                let alert = UIAlertController(title: "Warning", message: "This device can not send SMS messages", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        }
        
        
        let mailAction = UIAlertAction(title: "Mail", style: .default) { (alert) in
            
            
            if MFMailComposeViewController.canSendMail() {
                
                let mail:MFMailComposeViewController = MFMailComposeViewController()
                
                mail.mailComposeDelegate = self
                
                mail.setToRecipients(nil)
                mail.setSubject("Meet Verify!")
                mail.setMessageBody("Now #available #free on the #AppStore by @RazvanJulianDev! https://itunes.apple.com/us/app/verify-simple-intuitive-human/id1029172853?ls=1&mt=8", isHTML: false)
                
                self.present(mail, animated: true, completion: nil)
                
                
            } else {
                
                let alert = UIAlertController(title: "Accounts", message: "Please log into your email account within the Settings", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel , handler: nil)
        
        alertController.addAction(twitterAction)
        alertController.addAction(messageAction)
        alertController.addAction(mailAction)
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet var twitterButton: UIBarButtonItem!
    @IBOutlet var bannerView: GADBannerView!
    
    //var todoItems: [ToDoItem] = []
    
    var todoItems = [ToDoItem]()
    
    var refresher: UIRefreshControl!
    
    
    fileprivate let ITEMS_KEY = "todoItems"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "editToDoItem:", name: "actionOnePressed", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "shareToDoItem:", name: "actionTwoPressed", object: nil)
        
        

        // Uncomment the following line to preserve selection between presentations
         //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.navigationItem.leftBarButtonItems = [self.editButtonItem]
        
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList", name: "TodoListShouldRefresh", object: nil)
        
        
        
        //UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonPressed)];
        //UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed)];
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        

        //self.tableView.setNeedsLayout()
        //self.tableView.layoutIfNeeded()
    
        //tableView.allowsMultipleSelectionDuringEditing = true
        
        // Load any saved meals, otherwise load sample data.
        if let savedToDoItems = loadToDoItems() {
            todoItems += savedToDoItems
        }
        
        
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(ToDoTableViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(self.refresher)
        
        
        refresh()

        
        bannerView.isHidden = true
        bannerView.delegate = self
        
        
    }
    
    
    func refresh() {
        
        
        self.tableView.reloadData()
        self.refresher.endRefreshing()
        
        
    }
    
    
    
    /*
    func editToDoItem(notification:NSNotificationCenter){
        
        var tableView = UITableView()
        var indexPath = NSIndexPath()
        
        
        dispatch_async(dispatch_get_main_queue()){
            
            self.performSegueWithIdentifier("ShowDetail", sender: self)
            
        }
        
    }
    */
    
    /*
    func shareToDoItem(notification: NSNotificationCenter){
        
        if #available(iOS 8.0, *) {
            let shareAction = UITableViewRowAction(style: .Normal, title: "Share" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                
                let firstActivityItem = self.todoItems[indexPath.row]
                
                let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
                
                self.presentViewController(activityViewController, animated: true, completion: nil)
            })
        } else {
            // Fallback on earlier versions
        }
        
        
        
        /*
        
        var tableView: UITableView
        
        var indexPath = NSIndexPath()
        
        
        let firstActivityItem = self.todoItems[indexPath.row]
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        */
        
        
        /*var message: UIAlertController =  UIAlertController(title: "A Notification message", message:  "Hello there", preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(message, animated: true, completion: nil)
        */
        
        
    }
    
    */
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
       
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
        
        let save = UserDefaults.standard
        
        if save.value(forKey: "Verify.Purchase") == nil {
            
            
            bannerView.adUnitID = "ca-app-pub-8073575255978731/6048897362"
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
            
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            

            
        } else {
            
            bannerView.isHidden = true
            
        }
        
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        bannerView.isHidden = true
        
        
    }
    
    
    func refreshList() {
        //let todoItems = TodoList.sharedInstance.allItems()
        if (todoItems.count >= 64) {
            self.navigationItem.rightBarButtonItem!.isEnabled = false // disable 'add' button
        }
        tableView.reloadData()
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoItems.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       // let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) // retrieve the prototype cell (subtitle style)
        
        let cellIdentifier = "ToDoTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ToDoTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let todoItem = todoItems[indexPath.row] as ToDoItem
        
        cell.titleLabel.text = todoItem.title as String!
        
        if (todoItem.isOverdue) { // the current time is later than the to-do item's deadline
            cell.deadlineLabel.textColor = UIColor.red
            cell.noteLabel.textColor = UIColor.red
        } else {
            cell.deadlineLabel.textColor = UIColor.blue // we need to reset this because a cell with red subtitle may be returned by dequeueReusableCellWithIdentifier:indexPath:
            cell.noteLabel.textColor = UIColor.blue
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm " //...a" // example: "Due Jan 01 at 12:00 PM"
        cell.deadlineLabel.text = dateFormatter.string(from: todoItem.deadline as Date)
        cell.noteLabel.text = todoItem.note as String!
        cell.locationLabel.text = todoItem.location as String!
        cell.locationLabel.textColor = UIColor.darkGray
        
        
        return cell
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true // all cells are editable
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      /*  if editingStyle == .Delete { // the only editing style we'll support
            // Delete the row from the data source
          let item = todoItems.removeAtIndex(indexPath.row) // remove TodoItem from notifications array, assign removed item to 'item'
            saveToDoItems()
            setBadgeNumbers()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
           // TodoList.sharedInstance.removeItem(item) // delete backing property list entry and unschedule local notification (if it still exists)
            self.navigationItem.rightBarButtonItem!.enabled = true // we definitely have under 64 notifications scheduled now, make sure 'add' button is enabled
        }
        
        setBadgeNumbers()
     */

    }
    
    //////////////
    @available(iOS 8.0, *)
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) ->
        [UITableViewRowAction]?{
        
            let strikeAction = UITableViewRowAction(style: .normal, title: "Strike") { (rowAction:UITableViewRowAction, indexPath:IndexPath) -> Void in
            
            let todoItem = self.todoItems[indexPath.row]
                
                if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
                    cell.titleLabel.attributedText = self.strikeThroughText(text: todoItem.title)
                    
                    }
        }
        
        strikeAction.backgroundColor = UIColor.lightGray

        
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction:UITableViewRowAction, indexPath:IndexPath) -> Void in
            //TODO: Delete the row at indexPath here
            let todoItem = self.todoItems[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell{
                 cell.titleLabel.attributedText = NSAttributedString(string: todoItem.title)
            }
            self.todoItems.remove(at: indexPath.row)
            self.saveToDoItems()
            self.setBadgeNumbers()
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.navigationItem.rightBarButtonItem!.isEnabled = true
            
        }
        setBadgeNumbers()
        
        deleteAction.backgroundColor = UIColor.red
        
        
        return [deleteAction, strikeAction]
        
    }
    
    func strikeThroughText (text:String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))

        return attributeString
    }


    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let toDoItemDetailViewController = segue.destination as! ToDoItemsViewController
            // Get the cell that generated this segue.
            if let selectedToDoItemCell = sender as? ToDoTableViewCell {
                let indexPath = tableView.indexPath(for: selectedToDoItemCell)!
                let selectedToDoItem = todoItems[indexPath.row]
                toDoItemDetailViewController.todoItem = selectedToDoItem
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new todoItem.")
        }
    }
    
    
    func fixNotificationDate(_ dateToFix: Date) -> Date {
        var dateComponets: DateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.NSDayCalendarUnit, NSCalendar.Unit.NSMonthCalendarUnit, NSCalendar.Unit.NSYearCalendarUnit, NSCalendar.Unit.NSHourCalendarUnit, NSCalendar.Unit.NSMinuteCalendarUnit], from: dateToFix)
        
        dateComponets.second = 0
        
        let fixedDate: Date! = Calendar.current.date(from: dateComponets)
        
        return fixedDate
    }
    
    @IBAction func unwindToDoItemList(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ToDoItemsViewController, let todoItem = sourceViewController.todoItem {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing todoItem.
                todoItems[selectedIndexPath.row] = todoItem
                tableView.reloadRows(at: [selectedIndexPath], with: .top)
                
                
                let notification:UILocalNotification = UILocalNotification()
                //if #available(iOS 8.0, *) {
                    notification.category = "FIRST_CATEGORY"
                //} else {
                    // Fallback on earlier versions
                //}
                notification.alertBody = "You have to \(todoItem.title.lowercased())!" // "Hi, I am a notification"
                // notification.fireDate = fixNotificationDate(todoItem.deadline)
                notification.fireDate = fixNotificationDate(todoItem.deadline as Date)
                
                UIApplication.shared.scheduleLocalNotification(notification)
                
                
                
                setBadgeNumbers()
                
                
                
                
            } else {
                
                // Add a new todoItem.
                let newIndexPath = IndexPath(row: todoItems.count, section: 0)
                todoItems.append(todoItem)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                
                
                //scheduleLocalNotification(todoItem)
                let notification:UILocalNotification = UILocalNotification()
                //if #available(iOS 8.0, *) {
                    notification.category = "FIRST_CATEGORY"
                //} else {
                    // Fallback on earlier versions
                //}
                notification.alertBody = "Don't forget to \(todoItem.title.lowercased())!" // "Hi, I am a notification"
                // notification.fireDate = fixNotificationDate(todoItem.deadline)
                notification.fireDate = fixNotificationDate(todoItem.deadline as Date)
                
                UIApplication.shared.scheduleLocalNotification(notification)
                
                setBadgeNumbers()
                
                
                
            }
            
            // Save the todoItems.
           saveToDoItems()
            
        }
    }
    
    
    
    func setBadgeNumbers() {
        
        
        
        // MARK: OrderedAscending the tasks over Deadline in the list
        todoItems.sort { (left: ToDoItem, right: ToDoItem) -> Bool in
            (left.deadline.compare(right.deadline as Date) == .orderedAscending)
            
        }
        
        
        let overdueItems = todoItems.filter({ (todoItem) -> Bool in
            return todoItem.deadline.compare(Date()) != .orderedDescending
        })
        UIApplication.shared.applicationIconBadgeNumber = overdueItems.count  // set our badge number to number of overdue items
        
        let notifications = UIApplication.shared.scheduledLocalNotifications as [UILocalNotification]! // all scheduled notifications
        //let todoItems: [ToDoItem] = self.allItems()
        
        for notification in notifications! {
            let overdueItems = todoItems.filter({ (todoItem) -> Bool in // array of to-do items...
                return (todoItem.deadline.compare(notification.fireDate!) != .orderedDescending) // ...where item deadline is before or on notification fire date
                
                
                
            })
            
            UIApplication.shared.cancelLocalNotification(notification) // cancel old notification
            notification.applicationIconBadgeNumber = overdueItems.count // set new badge number
            UIApplication.shared.scheduleLocalNotification(notification) // reschedule notification
        }
    }
    
    
    
    // MARK: NSCoding
    
    func saveToDoItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(todoItems, toFile: ToDoItem.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save tasks...")
        }
    }
    
    func loadToDoItems() -> [ToDoItem]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ToDoItem.ArchiveURL.path) as? [ToDoItem]
    }

    

    
    /*
    
    
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeItem:", name: "actionOnePressed", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeItem:", name: "actionTwoPressed", object: nil)
    
    
    
    
    // persist a representation of this todo item in NSUserDefaults
    var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
    todoDictionary![todoItem.UUID] = ["deadline": todoItem.deadline, "note": todoItem.note, "title": todoItem.title, "UUID": todoItem.UUID] // store NSData representation of todo item in dictionary with UUID as key
    NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
    
    
    func removeItem() {
    for notification in UIApplication.sharedApplication().scheduledLocalNotifications as[UILocalNotification]! { // loop through notifications...
    if (notification.userInfo!["UUID"] as! String == todoItem.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
    UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
    break
    }
    }
    
    if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
    todoItems.removeValueForKey(todoItem.UUID)
    NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
    }
    
    self.setBadgeNumbers()
    }
    
    
    
    */
    
    // MARK: - Table view data source

/*

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

*/

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */


}
