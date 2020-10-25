//
//  DynamicItemsTableViewController.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/5/20.
//

import UIKit
import RealmSwift

class DynamicItemsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var categoriesDataSource: UITableView!
    
    var categoriesDBResults: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoriesDBResults?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let category = categoriesDBResults?[indexPath.row] {
            cell.textLabel?.text = category.title
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
        
    }
    
    func loadCategories() {
        
        categoriesDBResults = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        loadCategories()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "GoToItem") {
            
            let destinationVC = segue.destination as! ItemsTableViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoriesDBResults?[indexPath.row]
            }
        }
        
    }
    
    func searchCategories(_ itemsSearchBar: UISearchBar) {
        
        categoriesDBResults = categoriesDBResults?.filter("title CONTAINS[cd] %@", itemsSearchBar.text!)
        self.tableView.reloadData()
        
    }
    
}
