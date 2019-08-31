//
//  Reminder.swift
//  ReminderApp
//
//  Created by abhinav khanduja on 30/08/19.
//  Copyright © 2019 abhinav khanduja. All rights reserved.
//

import Foundation
import UserNotifications

class Reminder {
    
    static let shared = Reminder()
    
    let center = UNUserNotificationCenter.current()
    
    func schedule(reminder: ReminderData) {
        //Requesting user's access for notifications
        center.requestAuthorization(options: [.alert,.sound,.badge]) { (done, error) in
            if done {
                
                //Setting content to display inside notifications
                let content = UNMutableNotificationContent()
                content.title = "Reminder"
                content.body = reminder.message ?? "Something to do"
                content.sound = UNNotificationSound.default
                
                var dateComponents = self.getDateComponents(date: reminder.time!, beforeMins: 0)
                
                //converting timezone to indian timezone (responsible for triggering notification according to indian time)
                dateComponents.timeZone = TimeZone(abbreviation: "GMT")
                
                print("date components are ",dateComponents)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

                let uuid = reminder.uuid
                let request = UNNotificationRequest(identifier: uuid!, content: content, trigger: trigger)
                self.center.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        print("error occured: ",error as Any)
                    }
                })
            }
        }
    }
    
    private func getDateComponents(date: Date, beforeMins: Int) -> DateComponents {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        
        var components = calendar.dateComponents([.hour, .minute], from: date)
        
        components.minute = components.minute! - beforeMins
        
        return components
    }
    
    func getPendingNotifications(completion: @escaping(([String])->())) {
        var uuids : [String] = []
        center.getPendingNotificationRequests(completionHandler: { requests in
            uuids = requests.compactMap({$0.identifier})
            DispatchQueue.main.async {
                completion(uuids)
            }
        })
    }
}

extension Date {
    func getString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let str = dateFormatter.string(from: self)
        return str
    }
}
