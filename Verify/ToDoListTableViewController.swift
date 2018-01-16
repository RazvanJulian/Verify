//
//  ToDoListTableViewController.swift
//  Verify
//
//  Created by Razvan Julian on 13/09/17.
//
//


import UIKit

class ToDoListTableViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var textField: UITextField!
    
    var tableViewData = ["My Text 1","My Text 2"]
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: self.view.bounds.size.height-100), style: UITableViewStyle.plain)
        //self.tableView.registerClass(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "myCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
        
        // Set up text field
        self.textField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 100))
        self.textField.backgroundColor = UIColor.red
        self.textField.delegate = self
        
        self.view.addSubview(self.textField)
        
        
    }
    
    // TableViewDatasoruce
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return tableViewData.count
    }
    
    
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath) -> UITableViewCell!{
        
        let myNewCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        
        myNewCell.textLabel?.text = self.tableViewData[indexPath.row]
        myNewCell.accessoryType = .disclosureIndicator
        
        return myNewCell
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        //[viewController presentViewController:anotherController animated:YES completion:nil];
        
          
        let todoListViewController = ToDoTableViewController(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(todoListViewController, animated: true)
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let detailVC = segue.destination as! ToDoTableViewController
            //detailVC.park = self.parksArray[selectedRow]
        }
    }
    
    
    
    
    // TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        
        tableViewData.append(textField.text!)
        textField.text = ""
        self.tableView.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
    
}
