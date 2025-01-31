//
//  NotificationDelegate.swift
//  PlantBase
//
//  Created by user on 24.01.25.
//

import Foundation
import UserNotifications
import CoreData

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
            if let type = userInfo["type"] as? String, let frequency = userInfo["frequency"] as? Int16 {
                if type == "watering" {
                    // Reset water status for the specific frequency
                    PersistenceController.shared.updateWaterStatus(for: frequency)
                } else if type == "fertilizing" {
                    // Reset fertilizer status for the specific frequency
                    PersistenceController.shared.updateFertilizerStatus(for: frequency)
                }
            }
        
        print("Notification received: \(response.notification.request.content.body)")
        completionHandler()
    }
    
    
    func scheduleWateringNotifications(for frequency: Int16) {
        
        let identifier = frequency == 0 ? "manual_test_notification" : "watering_reminder_frequency_\(frequency)"
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        
        // Remove existing notification for this identifier
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        
        //****MANUAL NOTIFICATIONTRIGGER FOR TESTING AND DEBUG*****
        //START CODE-PART
        if frequency == 0 {
            
            
            // Modify fetchRequest predicate for manual test
            fetchRequest.predicate = NSPredicate(format: "requirementFrequencyWater == %d", 3) // for highest frequency group
            
            do {
                let plants = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
                let plantNames = plants.compactMap { $0.givenName ?? "Unnamed Plant" }.joined(separator: ", ")
                let reminderBody = String(format: NSLocalizedString("test_reminder_body", comment: ""), plantNames)
                
                let content = UNMutableNotificationContent()
                content.title = "Water Reminder"
                content.body = reminderBody
                content.sound = .default
                content.userInfo = ["frequency": 3, "type": "watering"]
                
                // 5-second delay trigger
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling manual notification: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error fetching plants for manual test: \(error.localizedDescription)")
            }
            
            return // Exit early after handling the manual test case
        }
        //*****END CODE PART FOR MANUAL NOTIFICATION TESTING
        //**************************************************
        
        
        //*****LOGIC FOR REGULAR SCHEDULING*****
        
        
        fetchRequest.predicate = NSPredicate(format: "requirementFrequencyWater == %d", frequency)
        
        do {
            let plants = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            let plantNames = plants.compactMap { $0.givenName ?? "Unnamed Plant" }.joined(separator: ", ")
            let reminderBody = String(format: NSLocalizedString("plant_reminder_water", comment: ""), plantNames)
            
            let content = UNMutableNotificationContent()
            content.title = "Water Reminder"
            content.body = reminderBody
            content.sound = .default
            content.userInfo = ["frequency": frequency, "type": "watering"]
            
            let triggers = makeWaterTriggers(for: frequency)
            for (index, trigger) in triggers.enumerated() {
                let request = UNNotificationRequest(identifier: "\(identifier)_\(index)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("Failed to fetch plants: \(error)")
        }
    }
    
    
    func scheduleFertilizerNotifications(for frequency: Int16) {
        
        let identifier = frequency == 0 ? "manual_test_notification" : "fertilizer_reminder_frequency_\(frequency)"
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        
        // Remove existing notification for this identifier
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        
        //****MANUAL NOTIFICATIONTRIGGER FOR TESTING AND DEBUG*****
        //START CODE-PART
        if frequency == 0 {
                        
            // Modify fetchRequest predicate for manual test
            fetchRequest.predicate = NSPredicate(format: "requirementFrequencyFertilizer == %d", 3) // for highest frequency group
            
            do {
                let plants = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
                let plantNames = plants.compactMap { $0.givenName ?? "Unnamed Plant" }.joined(separator: ", ")
                let reminderBody = String(format: NSLocalizedString("test_reminder_body", comment: ""), plantNames)
                
                let content = UNMutableNotificationContent()
                content.title = "Fertilizer Reminder"
                content.body = reminderBody
                content.sound = .default
                content.userInfo = ["frequency": 3, "type": "fertilizing"]
                
                // 5-second delay trigger
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling manual notification: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error fetching plants for manual test: \(error.localizedDescription)")
            }
            
            return // Exit early after handling the manual test case
        }
        //*****END CODE PART FOR MANUAL NOTIFICATION TESTING
        //**************************************************
        
        
        //*****LOGIC FOR REGULAR SCHEDULING*****
                
        fetchRequest.predicate = NSPredicate(format: "requirementFrequencyFertilizer == %d", frequency)
        
        do {
            let plants = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            let plantNames = plants.compactMap { $0.givenName ?? "Unnamed Plant" }.joined(separator: ", ")
            let reminderBody = String(format: NSLocalizedString("plant_reminder_fertilizer", comment: ""), plantNames)
            
            
            let content = UNMutableNotificationContent()
            content.title = "Fertilizer Reminder"
            content.body = reminderBody
            content.sound = .default
            content.userInfo = ["frequency": frequency, "type": "fertilizing"]
            
            let triggers = makeFertilizerTriggers(for: frequency)
            for (index, trigger) in triggers.enumerated() {
                let request = UNNotificationRequest(identifier: "\(identifier)_\(index)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("Failed to fetch plants: \(error)")
        }
    }
    
    
    
    func makeWaterTriggers(for frequency: Int16) -> [UNCalendarNotificationTrigger] {
        var triggers: [UNCalendarNotificationTrigger] = []
        
        let calendar = Calendar.current
        let currentDate = Date()
        let year = calendar.component(.year, from: currentDate)
        
        if frequency == 1 {
            // Predefines every second Sunday of the year
            for weekOfYear in stride(from: 2, through: 52, by: 2) {
                var components = DateComponents()
                components.year = year
                components.weekOfYear = weekOfYear
                components.weekday = 1 // Sunday
                components.hour = 9 // 9 AM
                
                if let triggerDate = calendar.date(from: components) {
                    triggers.append(UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.year, .month, .day, .hour], from: triggerDate), repeats: false))
                }
            }
        } else if frequency == 2 {
            // Every Sunday
            for weekOfYear in 1...52 {
                var components = DateComponents()
                components.year = year
                components.weekOfYear = weekOfYear
                components.weekday = 1 // Sunday
                components.hour = 9 // 9 AM
                
                if let triggerDate = calendar.date(from: components) {
                    triggers.append(UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.year, .month, .day, .hour], from: triggerDate), repeats: false))
                }
            }
        } else if frequency == 3 {
            // Twice a week: Sunday and Wednesday
            for weekOfYear in 1...52 {
                for weekday in [1, 4] { // Sunday = 1, Wednesday = 4
                    var components = DateComponents()
                    components.year = year
                    components.weekOfYear = weekOfYear
                    components.weekday = weekday
                    components.hour = 9 // 9 AM
                    
                    if let triggerDate = calendar.date(from: components) {
                        triggers.append(UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.year, .month, .day, .hour], from: triggerDate), repeats: false))
                    }
                }
            }
        }
        
        return triggers
    }
    
    
    func makeFertilizerTriggers(for frequency: Int16) -> [UNCalendarNotificationTrigger] {
        var triggers: [UNCalendarNotificationTrigger] = []
        
        let calendar = Calendar.current
        let currentDate = Date()
        let year = calendar.component(.year, from: currentDate)
        
        var strideValue = 1 // Default stride
        switch frequency {
        case 1: // Every eighth week
            strideValue = 8
        case 2: // Every fourth week
            strideValue = 4
        case 3: // Every second week
            strideValue = 2
        default:
            print("Invalid frequency for fertilizer notifications")
            return []
        }
        
        // Generates notification triggers
        for weekOfYear in stride(from: strideValue, through: 52, by: strideValue) {
            var components = DateComponents()
            components.year = year
            components.weekOfYear = weekOfYear
            components.weekday = 1 // Sunday
            components.hour = 9 // 9 AM
            
            if let triggerDate = calendar.date(from: components) {
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: calendar.dateComponents([.year, .month, .day, .hour], from: triggerDate),
                    repeats: false
                )
                triggers.append(trigger)
            }
        }
        
        return triggers
    }
    
}
