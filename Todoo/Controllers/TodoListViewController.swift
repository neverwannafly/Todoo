//
//  ViewController.swift
//  Todoo
//
//  Created by Shubham Anand on 17/07/18.
//  Copyright © 2018 Shubham Anand. All rights reserved.
//

import UIKit

class TodoListViewController : UITableViewController {

    var taskArray = [Task]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newTask1 = Task()
        newTask1.title = "Find Mike"
        taskArray.append(newTask1)
        
        let newTask2 = Task()
        newTask2.title = "Destroy Asgard"
        taskArray.append(newTask2)
        
        let newTask3 = Task()
        newTask3.title = "Fuck Rabbit"
        taskArray.append(newTask3)
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let task = taskArray[indexPath.row]
        
        cell.textLabel?.text = task.title
        cell.accessoryType = task.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        taskArray[indexPath.row].done = !taskArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            if textField.text != nil && textField.text != "" {
                let newTask = Task()
                newTask.title = textField.text!
                self.taskArray.append(newTask)
                self.defaults.set(self.taskArray, forKey: "TodoListArray")
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

