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
        
   //     self.tableView.delegate = self
   //     self.tableView.dataSource = self
  //      tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
    //    loadTasks()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        tableView.delegate = self
//        tableView.dataSource = self
//    //    loadTasks()
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows: \(tasksDBResults!.count)")
        return tasksDBResults?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("row: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)

        if let task = tasksDBResults?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.detailTextLabel?.text = String(task.time.dropLast(3))
            if task.alert == 90 {
                cell.imageView?.isHidden = true
            } else {
                cell.imageView?.isHidden = false
            }
        } else {
            cell.textLabel?.text = "No Items added"
        }

        return cell
    }

    func loadTasks() {
        
        
        tasksDBResults = realm.objects(Tasks.self)
        
        print("loadtask: \(tasksDBResults!.count)")
        
        print("mainqueue: \(Thread.isMainThread)")
        print("tableview: \(String(describing: self.tableView))")
        
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
