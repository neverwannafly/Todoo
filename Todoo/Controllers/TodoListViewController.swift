//
//  ViewController.swift
//  Todoo
//
//  Created by Shubham Anand on 17/07/18.
//  Copyright © 2018 Shubham Anand. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController : SwipeTableViewController {

    @IBOutlet weak var searchField: UISearchBar!
    
    let realm = try! Realm()
    var tasks: Results<Task>?
    
    var selectedCategory: Category? {
        didSet {
            loadTasks()
        }
    }
    

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let task = tasks?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Tasks Added"
        }
        
        if let color = UIColor(hexString: selectedCategory!.color)!.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(tasks!.count+2)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            cell.tintColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let task = tasks?[indexPath.row] {
            do {
                try realm.write {
                    task.done = !task.done
                }
            } catch {
                print(error)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            if textField.text != nil && textField.text != "" {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newTask = Task()
                            newTask.title = textField.text!
                            newTask.dateCreated = Date()
                            currentCategory.tasks.append(newTask)
                        }
                    } catch {
                        print(error)
                    }
                }
                
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
    
    //MARK: - CRUD operations on database
    
    func loadTasks() {

        tasks = selectedCategory?.tasks.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let taskDeletion = self.tasks?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(taskDeletion)
                }
            } catch {
                print(error)
            }
        }
    }
    
}

//MARK: - SearchBar extension
extension TodoListViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            title = selectedCategory!.name
            updateNavBar(withHexCode: colorHex)
            searchField.barTintColor = UIColor(hexString: colorHex)
            tableView.backgroundColor = UIColor(hexString: colorHex)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let color = UIColor(hexString: colorHexCode) else {fatalError("Yayay!")}
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Nav Controller doesnt exist")
        }
        navBar.barTintColor = color
        let contrastingColor = ContrastColorOf(color, returnFlat: true)
        navBar.tintColor = contrastingColor
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: contrastingColor]
        
    }
    
    func search(using searchBar: UISearchBar) {
        tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text!.count == 0 ? loadTasks() : search(using: searchBar)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text!.count == 0 ? loadTasks() : search(using: searchBar)
    }
    
    
}
