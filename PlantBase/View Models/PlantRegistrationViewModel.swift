//
//  PlantRegistrationViewModel.swift
//  PlantBase
//
//  Created by user on 21.01.25.
//

import Foundation
import SwiftUI
import PhotosUI
import CoreData

class PlantRegistrationViewModel: ObservableObject {

    private let context: NSManagedObjectContext
    let placeholderImageData: Data? = UIImage(named: "Profile")?.pngData()
    
    @Published var selectedPhoto: PhotosPickerItem? = nil
    @Published var profileImage: Image? = nil
    @Published var profileImageData: Data? = nil
    @Published var inputGivenName: String = ""
    @Published var inputBotanicalName: String = ""
    @Published var selectInputRequirementLight: Int = 1
    @Published var selectInputRequirementWater: Int = 1
    @Published var selectInputRequirementFertilizer: Int = 1
    @Published var selectedLocation: Location? = nil
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func savePlant() {
        guard let location = selectedLocation else {
            print("Error: Location not selected")
            return
        }
        
        let plant = Plant(context: context)
        plant.id = UUID()
        plant.profileImage = profileImageData ?? placeholderImageData
        plant.givenName = inputGivenName
        plant.botanicalName = inputBotanicalName
        plant.requirementFrequencyWater = Int16(selectInputRequirementWater)
        plant.requirementFrequencyFertilizer = Int16(selectInputRequirementFertilizer)
        plant.statusWater = false
        plant.statusFertilizer = false
        plant.location = location
        
        if let light = fetchLight(forIntensity: selectInputRequirementLight) {
            plant.light = light
        } else {
            print("Warning: No Light entity found for intensity \(selectInputRequirementLight).")
        }
        
        do {
            try context.save()
            print("Plant saved: \(plant.givenName ?? "")")
            PersistenceController.shared.refreshNotifications(for: Int16(selectInputRequirementWater), Int16(selectInputRequirementFertilizer)) // Triggers notification refresh
        } catch {
            print("Error saving plant: \(error)")
        }
    }
    
    private func fetchLight(forIntensity intensity: Int) -> Light? {
        let request: NSFetchRequest<Light> = Light.fetchRequest()
        request.predicate = NSPredicate(format: "intensityLight == %d", intensity)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching Light entity for intensity \(intensity): \(error)")
            return nil
        }
    }
    
    func processSelectedPhoto() async {
        guard let imageData = try? await selectedPhoto?.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: imageData) else {
            return
        }
        DispatchQueue.main.async {
            self.profileImage = Image(uiImage: uiImage)
            self.profileImageData = imageData
        }
    }
}

