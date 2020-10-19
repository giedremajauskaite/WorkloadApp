//
//  DynamicTasksController.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/7/20.
//

import UIKit
import RealmSwift

class DynamicTasksController: UITableViewController {
    
    var tasksDBResults: Results<Tasks>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        loadTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        loadTasks()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksDBResults?.count ?? 1
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell

        if let task = tasksDBResults?[indexPath.row] {
            cell.titleLabel.text = task.title
            cell.timeLabel.text = String(task.time.dropLast(3))
            if task.alert == 90 {
                cell.clockImageView.isHidden = true
            } else {
                cell.clockImageView.isHidden = false
            }
        } else {
            cell.textLabel?.text = "No Items added"
        }

        return cell
    }

    func loadTasks() {
        tasksDBResults = realm.objects(Tasks.self)
        tableView.reloadData()
    }

    func save(task: Tasks) {

        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
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
