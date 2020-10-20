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
  //      loadCategories()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        loadCategories()
//
//    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows: \(String(describing: categoriesDBResults?.count))")
        return categoriesDBResults?.count ?? 1
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("row: \(indexPath.row)")
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
        
        print("loaditem: \(categoriesDBResults!.count)")
        
        print("mainqueue: \(Thread.isMainThread)")
        print("tableview: \(String(describing: self.tableView))")
        
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
    
//    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        categoriesDBResults = categoriesDBResults?.filter("title CONTAINS[cd] %@", searchBar.text!)
//
//    }
//    
//    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0 {
//            loadCategories()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//
//    }
    
}


