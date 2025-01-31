//
//  LocationDetailView.swift
//  PlantBase
//
//  Created by user on 22.01.25.
//

import SwiftUI

struct LocationDetailView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel: LocationDetailViewModel
    
    let location: Location?
    
    init(location: Location?) {
        self.location = location
        _viewModel = StateObject(wrappedValue: LocationDetailViewModel(context: PersistenceController.shared.container.viewContext, location: location))
    }
    
    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Location_Details", comment: ""))) {
                TextField(NSLocalizedString("Room", comment: ""), text: $viewModel.room)
                TextField(NSLocalizedString("Position", comment: ""), text: $viewModel.position)
                
                Picker(NSLocalizedString("Light_Intensity", comment: ""), selection: $viewModel.lightIntensity) {
                    Text(NSLocalizedString("low", comment: "Low light intensity")).tag(1)
                    Text(NSLocalizedString("m-low", comment: "Medium-low light intensity")).tag(2)
                    Text(NSLocalizedString("m-high", comment: "Medium-high light intensity")).tag(3)
                    Text(NSLocalizedString("high", comment: "High light intensity")).tag(4)
                }
            }
            
            if let plants = viewModel.plants, !plants.isEmpty {
                Section(header: Text(NSLocalizedString("Ass_Plants", comment: ""))) {
                    
                    List(plants, id: \.id) { plant in
                        NavigationLink(destination: PlantprofileView(plant: plant)){
                            Text(plant.givenName ?? "Unnamed Plant")
                        }
                    }
                }
            } else {
                Section(header: Text(NSLocalizedString("Ass_Plants", comment: ""))) {
                    Text(NSLocalizedString("No_Plants", comment: ""))
                        .foregroundColor(.secondary)
                }
            }
            
            Button(NSLocalizedString("Save", comment: "")) {
                viewModel.saveLocation()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("Avocado"))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .navigationTitle(viewModel.isEditing ? "Edit Location" : NSLocalizedString("New_Location", comment: ""))
    }
}

