//
//  DynamicTasksController.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/7/20.
//

import UIKit
import RealmSwift
import SwipeCellKit

class DynamicTasksController: UITableViewController, SwipeTableViewCellDelegate {
    
    var tasksDBResults: Results<Tasks>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksDBResults?.count ?? 1
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        if let task = tasksDBResults?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.detailTextLabel?.text = String(task.time.dropLast(3))
            if task.alert == false {
                cell.imageView?.isHidden = true
            } else {
                cell.imageView?.isHidden = false
            }
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteTask(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
        
    }
    
    func loadTasks() {
        
        tasksDBResults = realm.objects(Tasks.self)
        self.tableView.reloadData()
    }
    
    func save(task: Tasks) {
        
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        loadTasks()
        
    }
    
    func deleteTask(at indexPath: IndexPath){
        
        if let task = tasksDBResults?[indexPath.row] {
            do {
                try realm.write {
                   realm.delete(task)
                }
            } catch {
                print("Error deleting Task, \(error)")
            }
        }
        loadTasks()
        
    }
    
    func searchTasks(_ itemsSearchBar: UISearchBar) {
        
        tasksDBResults = tasksDBResults?.filter("title CONTAINS[cd] %@", itemsSearchBar.text!)
        self.tableView.reloadData()
        
    }
    
}
