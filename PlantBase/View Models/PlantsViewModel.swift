//
//  PlantsViewModel.swift
//  PlantBase
//
//  Created by user on 23.01.25.
//

import Foundation
import CoreData

class PlantsViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
            self.context = context
        }
    
    func fetchPlants (in context: NSManagedObjectContext) {
        let request: NSFetchRequest<Plant> = Plant.fetchRequest()
        
        do {
            plants = try context.fetch(request)
        } catch {
            print("Error fetching plants: \(error)")
        }
    }
    
    func doesLightMatch(plant: Plant) -> Bool {
        guard let plantLight = plant.light?.intensityLight,
              let locationLight = plant.location?.light?.intensityLight else {
            return false // Return false if data is missing
        }
        return plantLight == locationLight
    }
}
