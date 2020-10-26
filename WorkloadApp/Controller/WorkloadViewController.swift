//
//  ViewController.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/2/20.
//

import UIKit
import UserNotifications

class WorkloadViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentsLabel: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var itemsContainer: UIView!
    @IBOutlet weak var tasksContainer: UIView!
    
    var dynamicItemsController: DynamicItemsController?
    var dynamicTasksController: DynamicTasksController?
    let center = UNUserNotificationCenter.current()
    
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
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if !granted {
                print("Error granting notifications, \(error!)")
            }
        }
        
    }
    
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
    @IBAction func addNewElementPressed(_ sender: UIBarButtonItem) {
        
        if segmentsLabel.selectedSegmentIndex == 1 {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
            
            let actionAdd = UIAlertAction(title: "Save", style: .default) { (action) in
                //Create new category
                let newCategory = Category()
                
                newCategory.title = textField.text!
                self.dynamicItemsController?.save(category: newCategory)
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
    
    //MARK: - Alert Notification
//    func scheduleNotification() {
//        
//        let center = UNUserNotificationCenter.current()
//        
//        let content = UNMutableNotificationContent()
//        content.title = "Task reminder"
//        content.body = "Task's text"
//        content.categoryIdentifier = "alarm"
//        content.sound = UNNotificationSound.default
//        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        dateComponents.second = 00
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        center.add(request)
//        
//    }
    
    
}

//MARK: - SearchBar
extension WorkloadViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if segmentsLabel.selectedSegmentIndex == 0 {
            self.dynamicTasksController?.searchTasks(searchBar)
        } else {
            self.dynamicItemsController?.searchCategories(searchBar)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
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
