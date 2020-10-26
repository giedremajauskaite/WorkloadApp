//
//  ItemsTableViewController.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/3/20.
//

import UIKit
import RealmSwift

class ItemsTableViewController: UITableViewController {
    
    @IBOutlet weak var itemsSearchBar: UISearchBar!
    @IBOutlet weak var itemsDataSource: UITableView!
    
    var categoryItems: Results<Items>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        itemsSearchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory!.title
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        if let item = categoryItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = categoryItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func loadItems() {
        
        categoryItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Items()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new Item, \(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            //Dismiss or present?
        }
        
        alert.addAction(actionCancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
        
    }
    
}

extension ItemsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ itemsSearchBar: UISearchBar) {
        
        categoryItems = categoryItems?.filter("title CONTAINS[cd] %@", itemsSearchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        self.tableView.reloadData()
        
    }
    
    func searchBar(_ itemsSearchBar: UISearchBar, textDidChange searchText: String) {
        
        if itemsSearchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                itemsSearchBar.resignFirstResponder()
            }
        }
        
    }
    
}
