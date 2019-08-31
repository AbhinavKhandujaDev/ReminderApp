//
//  ViewController.swift
//  ReminderApp
//
//  Created by abhinav khanduja on 30/08/19.
//  Copyright © 2019 abhinav khanduja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    private let identifier = "reminderCell"
    
    private var allReminders : [ReminderData] = []
    
    private var pendingNotifications : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Reminder.shared.getPendingNotifications { (uuids) in
            self.pendingNotifications = uuids
            print(self.pendingNotifications)
//            Reminder.shared.center.removePendingNotificationRequests(withIdentifiers: self.pendingNotifications)
            self.allReminders = DatabaseHandler.shared.getAllSavedReminders()
            self.allReminders.sort(by: {$0.time! < $1.time!})
            self.tableView.reloadData()
        }
    }
}

extension ViewController {
    
    //MARK:- TableView methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let row = allReminders[indexPath.row]
        cell.textLabel?.text = row.message
        cell.detailTextLabel?.text = row.time?.getString()
        print("time ",row.time)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let row = allReminders[indexPath.row]
//        if !pendingNotifications.contains(row.uuid!) {
//            cell.imageView?.image = #imageLiteral(resourceName: "check-mark")
//        }else {
//            cell.imageView?.image = nil
//        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        
        let rowObject = allReminders[indexPath.row]
        
        allReminders.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        guard let index = reminders.lastIndex(where: {$0.uuid == rowObject.uuid}) else {return}
        
        //removing notification from notifications cache
        Reminder.shared.center.removePendingNotificationRequests(withIdentifiers: [reminders[index].uuid!])
        
        //Deleting from local storage
        reminders.remove(at: index)
        DatabaseHandler.shared.deleteReminder(reminder: rowObject)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

