//
//  TasksTableViewController.swift
//  WorkloadApp
//  Coresponds to Create new task window in Main.storyboard
//  Creates new task and saves to realm db. Provides alerts details to Notification.swift file.
//
//  Created by Giedre Majauskaite on 10/3/20.
//

import UIKit
import RealmSwift

class TasksTableViewController: UITableViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var alertPicker: UIPickerView!
    
    let notifications = Notifications()
    
    var dynamicTasksController = DynamicTasksController()
    var alert = Alert()
    var onDismiss: (() -> ())?
    var datePicker: String = ""
    var alertTitle: String = "None"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        alertPicker.delegate = self
        alertPicker.dataSource = self
        taskName.delegate = self
        
        //Default datePicker date
        let df = DateFormatter()
        df.locale = NSLocale.current
        df.dateFormat = "yyyy-MM-dd HH:mm"
        datePicker = df.string(from: Date())
        
        //Looks for single or multiple taps to dismiss keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    //Create new task window headers' colour
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.968627451, green: 0.9490196078, blue: 0.9058823529, alpha: 1)
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    //MARK: - datePickerChanged
    // Task date
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        view.endEditing(true)
        let df = DateFormatter()
        df.locale = NSLocale.current
        df.dateFormat = "yyyy-MM-dd HH:mm"
        datePicker = df.string(from: sender.date)
        
    }
    
    //MARK: - saveTask
    // all task info collected after '+' is pressed and called save funtion from dynamicTasksController.swift
    // alarm time is calculted in calculateAlertTime
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        let newTask = Tasks()
        
        if let taskName = taskName.text, !taskName.isEmpty {
            newTask.title = taskName
            newTask.time = datePicker
        //    newTask.alert = alertTitle == "None" ? false : true
            newTask.alert = alertTitle
            
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
        let df = DateFormatter()
        df.locale = NSLocale.current
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let date = df.date(from: datePicker)
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
    
    // Dismiss keyboard after tasks description was filled and return button was pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        textField.resignFirstResponder()
        
        return true
    }
    
    // funcion is called after single or multiple taps. Ref tap variable.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // to dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
    
    // show alerts descpriotions
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return alert.alertsIntervals[row]
        
    }
    
    // alertTitle - alerts descpriotion
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        alertTitle = alert.alertsIntervals[row]
        
    }
    
}
