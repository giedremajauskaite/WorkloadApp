//
//  TasksTableViewController.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/3/20.
//

import UIKit
import RealmSwift

class TasksTableViewController: UIViewController  {

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var alertPicker: UIPickerView!
    
    var dynamicTasksController = DynamicTasksController()
    var alert = Alert()
    
    var alertTime: Int  = 90
    var datePicker: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPicker.delegate = self
        alertPicker.dataSource = self
        
        //Default datePicker date
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        datePicker = df.string(from: Date())
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        datePicker = df.string(from: sender.date)
        
    }
    
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        let newTask = Tasks()
        
        if let taskName = taskName.text, !taskName.isEmpty {
        
            newTask.title = taskName
            newTask.time = datePicker
            newTask.alert = alertTime
            
            dynamicTasksController.save(task: newTask)
            
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    

}


//MARK: - AlertPicker

extension TasksTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alert.alertsIntervals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return alert.alertsIntervals[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        alertTime = alert.alertsIntervals[row].time
    }
}
