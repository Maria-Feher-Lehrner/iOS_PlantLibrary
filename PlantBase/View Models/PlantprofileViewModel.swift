//
//  PlantprofileViewModel.swift
//  PlantBase
//
//  Created by user on 23.01.25.
//

import Foundation
import SwiftUI
import CoreData

class PlantprofileViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var plant: Plant
    
    @Published var givenName: String
    @Published var botanicalName: String
    @Published var profileImageData: Data
    @Published var profileImage: Image
    @Published var requirementFrequencyWater: Int
    @Published var requirementFrequencyFertilizer: Int
    @Published var requirementLight: Int
    @Published var statusWater: Bool
    @Published var statusFertilizer: Bool
    @Published var location: Location?
    
    
    
    
    init(context: NSManagedObjectContext, plant: Plant) {
        self.context = context
        self.plant = plant
        
        self.givenName = plant.givenName ?? ""
        self.botanicalName = plant.botanicalName ?? ""
        if let imageData = plant.profileImage, let uiImage = UIImage(data: imageData) {
                    self.profileImageData = imageData
                    self.profileImage = Image(uiImage: uiImage)
                } else {
                    // Replace "DefaultImage" with the actual default image name in your assets
                    let defaultImage = UIImage(named: "Profile")?.pngData() ?? Data()
                    self.profileImageData = defaultImage
                    self.profileImage = Image(uiImage: UIImage(data: defaultImage)!)
                }
        self.requirementFrequencyWater = Int(plant.requirementFrequencyWater)
        self.requirementFrequencyFertilizer = Int(plant.requirementFrequencyFertilizer)
        self.requirementLight = Int(plant.light?.intensityLight ?? 1)
        self.statusWater = plant.statusWater
        self.statusFertilizer = plant.statusFertilizer
        self.location = plant.location
        
    }
    
    func saveChanges() {
            plant.givenName = givenName
            plant.botanicalName = botanicalName
            plant.profileImage = profileImageData
            plant.requirementFrequencyWater = Int16(requirementFrequencyWater)
            plant.requirementFrequencyFertilizer = Int16(requirementFrequencyFertilizer)
            plant.light?.intensityLight = Int16(requirementLight)
            plant.statusWater = statusWater
            plant.statusFertilizer = statusFertilizer
            plant.location = location
            
            do {
                try context.save()
                PersistenceController.shared.refreshNotifications(for: Int16(requirementFrequencyWater), Int16(requirementFrequencyFertilizer)) // Triggers notification refresh
            } catch {
                print("Failed to save changes: \(error)")
            }
        }
        
        func updateProfileImage(_ imageData: Data) {
            profileImageData = imageData
            if let uiImage = UIImage(data: imageData) {
                profileImage = Image(uiImage: uiImage)
            }
        }
    
}
