//
//  WorkloadViewController.swift
//  WorkloadApp
//  Workload app has 2 sections. Tasks and items. Tasks might be time dependent - has alert functionaly.
//  Items are clasified to categories and each category can have elements (items).
//  Elements can be checked/uncheked
//  Main screen.
//
//  Created by Giedre Majauskaite on 10/2/20.
//

import UIKit

class WorkloadViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentsLabel: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var itemsContainer: UIView!
    @IBOutlet weak var tasksContainer: UIView!
    
    var dynamicItemsController: DynamicItemsController?
    var dynamicTasksController: DynamicTasksController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        //Default values
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        self.dateLabel.text = formatter.string(from: date)
        
        self.itemsContainer.isHidden = true
        self.segmentsLabel.selectedSegmentIndex = 0
        
        overrideUserInterfaceStyle = .light
        
        //Dismiss searchbar keyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    //MARK: - prepares 2 containers for tasks and items, loads elements
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TasksSegue" {
            let destinationVC = segue.destination as! DynamicTasksController
            self.dynamicTasksController = destinationVC
            destinationVC.loadTasks()
        } else if segue.identifier == "ItemsSegue" {
            let destinationVC = segue.destination as! DynamicItemsController
            self.dynamicItemsController = destinationVC
            destinationVC.loadCategories()
        } else if segue.identifier == "CreateNewTask" {
            let destinationVC = segue.destination as! TasksTableViewController
            destinationVC.onDismiss = {
                self.dynamicTasksController?.loadTasks()
            }
        }
        
    }
    
    //MARK: - Function to switch Tasks and Items bar, reload elements
    @IBAction func segmentsIndexChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.itemsContainer.isHidden = true
            self.dynamicTasksController?.loadTasks()
        } else {
            self.itemsContainer.isHidden = false
            self.dynamicItemsController?.loadCategories()
        }
        
    }
    
    //MARK: - addNewElementPressed
    //If segment = Tasks (0), performs new window - TasksTableViewController
    //If segment = Items (1), performs alert message to create new items cagategory
    @IBAction func addNewElementPressed(_ sender: UIBarButtonItem) {
        
        if segmentsLabel.selectedSegmentIndex == 1 {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
            
            let actionAdd = UIAlertAction(title: "Save", style: .default) { (action) in
                if !textField.text!.isEmpty {
                //Create new category
                let newCategory = Category()
                newCategory.title = textField.text!
                self.dynamicItemsController?.save(category: newCategory)
                }
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new category"
                textField = alertTextField
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            }
            
            actionCancel.setValue(UIColor.black, forKey: "titleTextColor")
            actionAdd.setValue(UIColor.black, forKey: "titleTextColor")
            
            alert.addAction(actionCancel)
            alert.addAction(actionAdd)
            
            present(alert, animated: true, completion: nil )
            
        } else {
            performSegue(withIdentifier: "CreateNewTask", sender: self)
        }
        
    }
    
}

//MARK: - SearchBar
extension WorkloadViewController: UISearchBarDelegate {
    
    var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !isSearchBarEmpty {
            if segmentsLabel.selectedSegmentIndex == 0 {
                self.dynamicTasksController?.searchTasks(searchBar)
            } else {
                self.dynamicItemsController?.searchCategories(searchBar)
            }
        } else {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Reloads info after 'x' was pressed in the searchbarfield
        if searchBar.text?.count == 0 {
            if segmentsLabel.selectedSegmentIndex == 0 {
                self.dynamicTasksController?.loadTasks()
            } else {
                self.dynamicItemsController?.loadCategories()
            }
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}
