//
//  PlantBaseApp.swift
//  PlantBase
//
//  Created by user on 20.01.25.
//

import SwiftUI
import UserNotifications

@main
struct PlantBaseApp: App {
    let persistenceController = PersistenceController.shared
    let notificationDelegate = NotificationDelegate()
    
    
    init() {
        configureGlobalAppearance()
        UNUserNotificationCenter.current().delegate = notificationDelegate
        requestNotificationPermissions()
        
        
        //++++FOR TESTING DURING DEVELOPMENT++++
        //persistenceController.clearEntities(entities: ["Location", "Plant"])
        persistenceController.initializeDevelopmentData()
        
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
