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
    
    let notifications = Notifications()
    
    var dynamicTasksController = DynamicTasksController()
    var alert = Alert()
    var onDismiss: (() -> ())?
    var datePicker: String = ""
    var alertTitle: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        alertPicker.delegate = self
        alertPicker.dataSource = self
        
        //Default datePicker date
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datePicker = df.string(from: Date())
    
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datePicker = df.string(from: sender.date)
        
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        let newTask = Tasks()
        
        if let taskName = taskName.text, !taskName.isEmpty {
            newTask.title = taskName
            newTask.time = datePicker
            newTask.alert = taskName == "None" ? false : true
            
            dynamicTasksController.save(task: newTask)
            
            //If alertTime value wasnt selected as "None", create an alert
            if alertTitle != "None" {
                let alertDate = calculateAlertTime(datePicker: datePicker, alertTitle: alertTitle)
                self.notifications.scheduleNotification(notificationText: taskName, notificationDate: alertDate)
            }
            
        }
        self.onDismiss?()
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    //Calculate alert time using time and alert params from pickers as inputs
    func calculateAlertTime(datePicker: String, alertTitle: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: datePicker)
        let calendar = Calendar.current
        let date1: Date
        
        switch alertTitle {
        case "5 minutes before":
            date1 = calendar.date(byAdding: .minute, value: -5, to: date!)!
        case "10 minutes before":
            date1 = calendar.date(byAdding: .minute, value: -10, to: date!)!
        case "15 minutes before":
            date1 = calendar.date(byAdding: .minute, value: -15, to: date!)!
        case "1 hour before":
            date1 = calendar.date(byAdding: .hour, value: -1, to: date!)!
        case "2 hours before":
            date1 = calendar.date(byAdding: .hour, value: -2, to: date!)!
        case "1 day before":
            date1 = calendar.date(byAdding: .day, value: -1, to: date!)!
        case "2 days before":
            date1 = calendar.date(byAdding: .day, value: -2, to: date!)!
        case "1 week before":
            date1 = calendar.date(byAdding: .weekOfMonth, value: -1, to: date!)!
        default:
            date1 = date!
        }
        return date1
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
        
        return alert.alertsIntervals[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        alertTitle = alert.alertsIntervals[row]
        
    }
    
}
