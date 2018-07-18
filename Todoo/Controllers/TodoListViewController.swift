//
//  ViewController.swift
//  Todoo
//
//  Created by Shubham Anand on 17/07/18.
//  Copyright © 2018 Shubham Anand. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController : UITableViewController {

    @IBOutlet weak var searchField: UISearchBar!
    
    var taskArray = [Task]()
    var selectedCategory: Category? {
        didSet {
            loadTasks()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - Tableview Datasource Methods
    
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
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        taskArray[indexPath.row].done = !taskArray[indexPath.row].done
        saveTasks()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            if textField.text != nil && textField.text != "" {
                
                let newTask = Task(context: self.context)
                
                newTask.title = textField.text!
                newTask.parentCategory = self.selectedCategory
                
                self.taskArray.append(newTask)
                
                self.saveTasks()
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - CRUD operations on database
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            taskArray = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func deleteTasks(indexPath: IndexPath) {
        context.delete(taskArray[indexPath.row])
        taskArray.remove(at: indexPath.row)
        saveTasks()
    }
    
    
}

//MARK: - SearchBar extension
extension TodoListViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
    }
    
    func search(using searchBar: UISearchBar) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadTasks(with: request, predicate: predicate)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text!.count == 0 ? loadTasks() : search(using: searchBar)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text!.count == 0 ? loadTasks() : search(using: searchBar)
    }
    
    
}
