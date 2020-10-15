//
//  ViewController.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/2/20.
//

import UIKit

class WorkloadViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentsLabel: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var itemsContainer: UIView!
    
    var dynamicItemsController = DynamicItemsController()
    var dynamicTasksController = DynamicTasksController()
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        super.viewWillAppear(animated)
//
//        if segmentsLabel.selectedSegmentIndex == 0 {
//            
//             func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//                if (segue.identifier == "GoToItem") {
//
//                let destinationVC = segue.destination as! DynamicItemsController
//
//                    dynamicTasksController.loadTasks()
//                }
//            }
//
//        }
//        else {
//            print("2")
//            dynamicItemsController.loadCategories()
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        //set Date label
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        self.dateLabel.text = formatter.string(from: date)
        
        self.itemsContainer.isHidden = true
        self.segmentsLabel.selectedSegmentIndex = 0
        self.dynamicTasksController.loadTasks()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TasksSegue" {
            let destinationVC = segue.destination as! DynamicTasksController
            destinationVC.loadTasks()
        } else if segue.identifier == "ItemsSegue" {
            let destinationVC = segue.destination as! DynamicItemsController
            destinationVC.loadCategories()
        }
        
    }
    
    
    @IBAction func segmentsIndexChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.itemsContainer.isHidden = true
        } else {
            self.itemsContainer.isHidden = false
        }
        
    }
    
//MARK: - addNewElementPressed
    
    @IBAction func addNewElementPressed(_ sender: UIBarButtonItem) {
        
        if segmentsLabel.selectedSegmentIndex == 1 {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
            
            let actionAdd = UIAlertAction(title: "Save", style: .default) { (action) in
                //Create new category
                let newCategory = Category()
                
                newCategory.title = textField.text!
                
                self.dynamicItemsController.save(category: newCategory)
                self.dynamicItemsController.loadCategories()
                
                
//                let tv : UITableViewController = self.children[0] as! DynamicItemsController
//                tv.tableView.reloadData()
//                tv.viewWillAppear(true)
            }
                    
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new Category"
                textField = alertTextField
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                //Dismiss or present?
            }
            
            alert.addAction(actionCancel)
            alert.addAction(actionAdd)
            
            present(alert, animated: true, completion: nil )
            
        } else {
            performSegue(withIdentifier: "CreateNewTask", sender: self)
        }
        
    }


 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

}

 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

}

}
