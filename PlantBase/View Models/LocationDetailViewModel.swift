//
//  LocationDetailViewModel.swift
//  PlantBase
//
//  Created by user on 22.01.25.
//

import Foundation
import CoreData

class LocationDetailViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var existingLocation: Location?
    
    @Published var room: String = ""
    @Published var position: String = ""
    @Published var lightIntensity: Int = 1
    @Published var plants: [Plant]? = nil
    
    var isEditing: Bool {
        existingLocation != nil
    }
    
    init(context: NSManagedObjectContext, location: Location?) {
        self.context = context
        self.existingLocation = location
        
        if let location = location {
            self.room = location.room ?? ""
            self.position = location.position ?? ""
            self.lightIntensity = Int(location.light?.intensityLight ?? 1)
            fetchPlants(for: location)
    
        }
    }
    
    func saveLocation() {
        let location = existingLocation ?? Location(context: context)
        
        location.id = UUID()
        location.room = room
        location.position = position
        
        // Fetches or creates the associated Light object
        if let light = fetchLight(with: lightIntensity) {
            location.light = light
        }
        
        if context.hasChanges {
            do {
                try context.save()
                print("Location saved successfully.")
            } catch {
                print("Error saving location: \(error)")
            }
        }
    }
    
    private func fetchLight(with intensity: Int) -> Light? {
        let request: NSFetchRequest<Light> = Light.fetchRequest()
        request.predicate = NSPredicate(format: "intensityLight == %d", intensity)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching light: \(error)")
            return nil
        }
    }
    
    func fetchPlants(for location: Location) {
        let plants = location.plants?.allObjects as? [Plant] ?? []
        print("Fetched \(plants.count) plants for location \(location.room ?? "Unknown")")
        
        DispatchQueue.main.async {
                self.plants = plants
            }
    }

    
}
