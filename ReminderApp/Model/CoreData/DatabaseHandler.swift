//
//  DatabaseHandler.swift
//  ReminderApp
//
//  Created by abhinav khanduja on 30/08/19.
//  Copyright © 2019 abhinav khanduja. All rights reserved.
//

import Foundation
import CoreData

var reminders : [ReminderData] = DatabaseHandler.shared.getAllSavedReminders()

class DatabaseHandler {
    
    static let shared = DatabaseHandler()
    
    func getContext() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ReminderCoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addReminderToDatabase(message: String, date: Date) {
        let entity = ReminderData(context: getContext())
        entity.message = message
        entity.time = date
        entity.uuid = UUID().uuidString
        saveContext()

        Reminder.shared.schedule(reminder: entity)
    }
    
    func getAllSavedReminders() -> [ReminderData] {
        var reminders = [ReminderData]()
        let request : NSFetchRequest<ReminderData> = ReminderData.fetchRequest()
        do {
            reminders = try getContext().fetch(request)
        }catch {
            print("Error in fetching")
        }
        return reminders
    }
    
    func deleteReminder(reminder: ReminderData) {
        getContext().delete(reminder)
        saveContext()
    }
}
