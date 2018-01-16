//
//  ToDoItemsViewController.swift
//  Verify
//
//  Created by Razvan Julian on 17/07/15.
//  Copyright (c) 2015 Razvan Julian. All rights reserved.
//

import UIKit
import GoogleMobileAds

var places = [Dictionary <String, String>()]


class ToDoItemsViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var bannerView: GADBannerView!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    @IBOutlet weak var noteField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var MapLabel: UILabel!
    
    
 /* @IBAction func savePressed(sender: UIBarButtonItem) {
        let todoItem = ToDoItem(deadline: deadlinePicker.date, note: noteField.text!, title: titleField.text!, UUID: NSUUID().UUIDString)
        TodoList.sharedInstance.addItem(todoItem!) // schedule a local notification to persist this item
        self.navigationController?.popToRootViewControllerAnimated(true) // return to list view
    }  */
    
    
    
    var todoItem: ToDoItem?
        
    
    fileprivate let ITEMS_KEY = "todoItems"    
    
    
    @IBOutlet weak var toggle: UISwitch!
    
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        tableView.reloadData()
        
                
    }
    
    
    @IBOutlet weak var date: UILabel!

    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.medium
            date.text = dateFormatter.string(from: sender.date)
        
        
        }
    
    
    var pickerVisible = false
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            pickerVisible = !pickerVisible
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && toggle.isOn == false {
            return 0.0
        }
        if indexPath.row == 2 {
            if toggle.isOn == false || pickerVisible == false {
                return 0.0
            }
            return 165.0
        }
        return 44.0
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkTaskName()
        
        // Handle the text field’s user input through delegate callbacks.
        titleField.delegate = self
        
        
        if let todoItem = todoItem {
            navigationItem.title = todoItem.title
            titleField.text = todoItem.title
            deadlinePicker.date = todoItem.deadline as Date
            noteField.text = todoItem.note
            MapLabel.text = todoItem.location
        }
        
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        // Do any additional setup after loading the view.
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        MapLabel.text = ""
                
        
    }

    
        
    
    override func viewDidAppear(_ animated: Bool) {
        
        MapLabel.text = mapTitle
        
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTaskName()
        navigationItem.title = textField.text
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func checkTaskName() {
        // Disable the Save button if the text field is empty.
        let text = titleField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddToDoItemMode = presentingViewController is UINavigationController
        
        if isPresentingInAddToDoItemMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)

        }
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if saveButton == (sender as? UIBarButtonItem) {
            _ = titleField.text ?? ""
            _ = noteField.text
            _ = deadlinePicker.date
            _ = MapLabel.text
            
            
            //let UUID = NSUUID().UUIDString
            
            
            // Set the meal to be passed to MealListTableViewController after the unwind segue.
            todoItem = ToDoItem(deadline: deadlinePicker.date, note: noteField.text!, location: MapLabel.text!, title: titleField.text!)//, UUID: NSUUID().UUIDString )
            
            //TodoList.sharedInstance.addItem(todoItem!) // schedule a local notification to persist this item
            
            
            self.navigationController?.popToRootViewController(animated: true) // return to list view
            
            
    
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }

    
    
    
    /* @IBAction func savePressed(sender: UIBarButtonItem) {
    
    let todoItem = ToDoItem(deadline: deadlinePicker.date, note: noteField.text!, title: titleField.text!, UUID: NSUUID().UUIDString)
    
    TodoList.sharedInstance.addItem(todoItem!) // schedule a local notification to persist this item
    
    self.navigationController?.popToRootViewControllerAnimated(true) // return to list view
    }  */
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
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
