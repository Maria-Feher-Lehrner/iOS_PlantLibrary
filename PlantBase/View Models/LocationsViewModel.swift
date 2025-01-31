//
//  LocationsViewModel.swift
//  PlantBase
//
//  Created by user on 21.01.25.
//

import Foundation
import CoreData

class LocationsViewModel: ObservableObject {
    @Published var locations: [Location] = []
    
    func fetchLocations(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        
        do {
            locations = try context.fetch(request)
        } catch {
            print("Error fetching locations: \(error)")
        }
    }
}

