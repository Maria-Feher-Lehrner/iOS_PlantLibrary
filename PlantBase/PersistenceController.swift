//
//  PersistenceController.swift
//  PlantBase
//
//  Created by user on 21.01.25.
//

import Foundation
import CoreData
import SwiftUI

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PlantBase")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        populateFixedLightsIfNeeded()
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func createPlant(profileImage: Data, givenName: String, botanicalName: String, lightIntensity: Int, water: Int, fertilizer: Int, location: Location) -> Plant {
        let context = container.viewContext
        let newPlant = Plant(context: context)
        newPlant.id = UUID()
        newPlant.profileImage = profileImage
        newPlant.givenName = givenName
        newPlant.botanicalName = botanicalName
        newPlant.requirementFrequencyWater = Int16(water)
        newPlant.requirementFrequencyFertilizer = Int16(fertilizer)
        newPlant.statusFertilizer = false
        newPlant.statusWater = false
        newPlant.location = location
        
        if let light = fetchLight(forIntensity: lightIntensity) {
                    newPlant.light = light
                } else {
                    print("Warning: No Light entity found for intensity \(lightIntensity).")
                }
                
        
        return newPlant
    }
    
    
    func refreshNotifications(for frequencyWater: Int16, _ frequencyFertilizer: Int16) {
        let notificationDelegate = NotificationDelegate()

            // Refreshes watering notifications for each frequency group
            notificationDelegate.scheduleWateringNotifications(for: Int16(frequencyWater))
            
            // Refreshes fertilizer notifications for each frequency group
            notificationDelegate.scheduleFertilizerNotifications(for: Int16(frequencyFertilizer))
            
        }
    
    
    
    // Fetch a Light entity by intensity
        func fetchLight(forIntensity intensity: Int) -> Light? {
            let context = container.viewContext
            let fetchRequest: NSFetchRequest<Light> = Light.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "intensityLight == %d", intensity)

            do {
                return try context.fetch(fetchRequest).first
            } catch {
                print("Error fetching Light entity for intensity \(intensity): \(error)")
                return nil
            }
        }
    
    // Pre-populate the fixed Light entities as out-of-the-box setting that automatically comes with the app
        func populateFixedLightsIfNeeded() {
            let context = container.viewContext
            let fetchRequest: NSFetchRequest<Light> = Light.fetchRequest()

            do {
                let existingLights = try context.fetch(fetchRequest)
                if existingLights.isEmpty {
                    // If no Light entities exist, create 4 default Light instances
                    for i in 1...4 {
                        let light = Light(context: context)
                        light.intensityLight = Int16(i)
                    }
                    try context.save()
                }
            } catch {
                print("Error fetching or saving Light instances: \(error)")
            }
        }
    
    // Fetches List of all instances of Plant Entities
    func fetchPlants() -> [Plant] {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        do {
            let plants = try container.viewContext.fetch(fetchRequest)
            return plants
        } catch {
            print("Error fetching plants: \(error)")
            return []
        }
    }
    
    func updateWaterStatus(for frequency: Int16) {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "requirementFrequencyWater == %d", frequency)
            
        do {
            let plants = try container.viewContext.fetch(fetchRequest)
            for plant in plants {
                plant.statusWater = false
            }
            try container.viewContext.save()
            print("Updated statusWater for all plants with frequency \(frequency) to false.")
        } catch {
            print("Failed to update statusWater: \(error)")
        }
    }
    
    
    func updateFertilizerStatus(for frequency: Int16) {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "requirementFrequencyFertilizer == %d", frequency)
            
        do {
            let plants = try container.viewContext.fetch(fetchRequest)
            for plant in plants {
                plant.statusFertilizer = false
            }
            try container.viewContext.save()
            print("Updated statusFertilizer for all plants with frequency \(frequency) to false.")
        } catch {
            print("Failed to update statusFrequency: \(error)")
        }
    }
    
}



//*****EXTENSION FOR POPULATING APP WITH INITIAL DATA FOR DEVELOPMENT AND TESTING PURPOSES*****

extension PersistenceController {
    func clearEntities(entities: [String]) {
            let context = container.viewContext
            for entity in entities {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try context.execute(deleteRequest)
                    try context.save()
                } catch {
                    print("Failed to clear \(entity): \(error)")
                }
            }
        }
    
    func initializeDevelopmentData() {
        let context = container.viewContext
        
        // Check if any Location exists
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                // No data exists, create initial setup
                createInitialData(context: context)
            }
        } catch {
            print("Error checking for existing data: \(error)")
        }
    }
    
    private func createInitialData(context: NSManagedObjectContext) {
        let defaultImage = UIImage(named: "Profile")?.pngData() ?? Data()
        
        // Create a Light instance for room and plants
        let lightRoom = Light(context: context)
        lightRoom.intensityLight = 2
        
        let lightPlantDifferent = Light(context: context)
        lightPlantDifferent.intensityLight = 4
        
        // Create a Location
        let location = Location(context: context)
        location.id = UUID()
        location.room = "Living Room"
        location.position = "Near the window"
        location.light = lightRoom
        
        // Create Plant 1 (matching light requirement of room)
        let plantMatching = Plant(context: context)
        plantMatching.id = UUID()
        plantMatching.givenName = "Aloe Vera"
        plantMatching.botanicalName = "Aloe barbadensis miller"
        plantMatching.light = lightRoom
        plantMatching.requirementFrequencyWater = 2
        plantMatching.requirementFrequencyFertilizer = 1
        plantMatching.statusWater = false
        plantMatching.statusFertilizer = false
        plantMatching.location = location
        plantMatching.profileImage = defaultImage
        
        // Create Plant 2 (different light requirement from room)
        let plantDifferent = Plant(context: context)
        plantDifferent.id = UUID()
        plantDifferent.givenName = "Cactus"
        plantDifferent.botanicalName = "Carnegiea gigantea"
        plantDifferent.light = lightPlantDifferent
        plantDifferent.requirementFrequencyWater = 1
        plantDifferent.requirementFrequencyFertilizer = 2
        plantDifferent.statusWater = false
        plantDifferent.statusFertilizer = false
        plantDifferent.location = location
        plantDifferent.profileImage = defaultImage
        
        print("Creating Location with room: \(location.room ?? "Unknown")")
        print("Creating Plants: \(plantMatching.givenName ?? "Unknown") and \(plantDifferent.givenName ?? "Unknown")")

        
        // Save changes
        do {
            try context.save()
            print("Development data initialized successfully.")
        } catch {
            print("Error saving initial data: \(error)")
        }
    }
}


