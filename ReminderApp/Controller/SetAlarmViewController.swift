//
//  SetAlarmViewController.swift
//  ReminderApp
//
//  Created by abhinav khanduja on 30/08/19.
//  Copyright © 2019 abhinav khanduja. All rights reserved.
//

import UIKit

class SetAlarmViewController: UIViewController {

    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var dateSelectedLabel: UILabel!
    
    @IBOutlet weak var reminderMessageTxtField: UITextField!
    
    @IBOutlet weak var addBtn: UIButton!
    
    let dbHandler = DatabaseHandler.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    private func configureDatePicker() {
        datePickerView.datePickerMode = .time
        let date = datePickerView.date
        dateSelectedLabel.text = date.getString()
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        guard let message = reminderMessageTxtField.text else { return }
        dbHandler.addReminderToDatabase(message: message, date: datePickerView.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        dateSelectedLabel.text = datePickerView.date.getString()
    }
}
