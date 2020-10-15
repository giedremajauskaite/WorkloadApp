//
//  TasksTableViewController.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/3/20.
//

import UIKit
import RealmSwift

class TasksTableViewController: UIViewController {

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    
    var dynamicTasksController = DynamicTasksController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        let newTask = Tasks()
        
        if let taskName = taskName.text, !taskName.isEmpty {
        
            newTask.title = taskName
            
            dynamicTasksController.save(task: newTask)
            
        }
        
        navigationController?.popToRootViewController(animated: true)
        
    }

}
