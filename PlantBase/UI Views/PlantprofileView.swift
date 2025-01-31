//
//  PlantprofileView.swift
//  PlantBase
//
//  Created by user on 20.01.25.
//

import SwiftUI
import PhotosUI

struct PlantprofileView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: PlantprofileViewModel
    @State private var plant: Plant
    @State private var profileImage: UIImage?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var dropScale: CGFloat = 0
    @State private var leafScale: CGFloat = 0
    
    @FetchRequest(
        entity: Location.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.room, ascending: true)]
    ) private var locations: FetchedResults<Location>
    
    
    init(plant: Plant) {
        _plant = State(initialValue: plant)
        _viewModel = StateObject(wrappedValue: PlantprofileViewModel(context: PersistenceController.shared.container.viewContext, plant: plant))
        if let imageData = plant.profileImage, let uiImage = UIImage(data: imageData) {
            _profileImage = State(initialValue: uiImage)
        } else {
            _profileImage = State(initialValue: UIImage(named: "Profile"))
        }
    }
    
    var body: some View {
        Form {
            
            Section {
                VStack {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    } else {
                        Image("Profile")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                    
                    PhotosPicker(selection: $selectedPhoto) {
                        HStack {
                            Label(NSLocalizedString("Change_photo", comment: ""), systemImage: "photo")
                        }
                    }
                    .onChange(of: selectedPhoto) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                self.profileImage = image
                                self.viewModel.updateProfileImage(data)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            Section(header: Text(NSLocalizedString("Plant_details", comment: ""))) {
                TextField(NSLocalizedString("Given_Name", comment: ""), text: $viewModel.givenName)
                TextField(NSLocalizedString("Botanical_Name", comment: ""), text: $viewModel.botanicalName)
            }
            
            Section(header: Text(NSLocalizedString("Requirements", comment: ""))) {
                VStack(alignment: .leading){
                    Text(NSLocalizedString("Water", comment: ""))
                    Picker(NSLocalizedString("Water_Frequency", comment: ""), selection: $viewModel.requirementFrequencyWater) {
                        Text(NSLocalizedString("2/w", comment: "")).tag(3)
                        Text(NSLocalizedString("1/w", comment: "")).tag(2)
                        Text(NSLocalizedString("0.5/w", comment: "")).tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                VStack(alignment: .leading){
                    Text(NSLocalizedString("Fertilizer", comment: ""))
                    Picker(NSLocalizedString("Fertilizer_Frequency", comment: ""), selection: $viewModel.requirementFrequencyFertilizer) {
                        Text(NSLocalizedString("2/m", comment: "")).tag(3)
                        Text(NSLocalizedString("1/m", comment: "")).tag(2)
                        Text(NSLocalizedString("0.5/m", comment: "")).tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                VStack(alignment: .leading){
                    Text(NSLocalizedString("Light", comment: ""))
                    Picker(NSLocalizedString("Light_Intensity", comment: ""), selection: $viewModel.requirementLight) {
                        Text(NSLocalizedString("low", comment: "")).tag(1)
                        Text(NSLocalizedString("m-low", comment: "")).tag(2)
                        Text(NSLocalizedString("m-high", comment: "")).tag(3)
                        Text(NSLocalizedString("high", comment: "")).tag(4)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            
            Section(header: Text(NSLocalizedString("Status", comment: ""))) {
                HStack {
                    Toggle(NSLocalizedString("Watered", comment: ""), isOn: $viewModel.statusWater)
                        .onChange(of: viewModel.statusWater) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                dropScale = viewModel.statusWater ? 1 : 0
                            }
                        }
                    Spacer()
                    ZStack {
                        Image(systemName: "drop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("Water light_blue"))
                        
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("Water blue"))
                            .scaleEffect(CGSize(width: 1, height: dropScale))
                            .clipped()
                            .animation(.easeInOut(duration: 0.3), value: dropScale)
                    }
                }
                HStack {
                    Toggle(NSLocalizedString("Fertilized", comment: ""), isOn: $viewModel.statusFertilizer)
                        .onChange(of: viewModel.statusFertilizer) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                leafScale = viewModel.statusFertilizer ? 1 : 0
                            }
                        }
                    Spacer()
                    ZStack{
                        Image(systemName: "leaf")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("Sage"))
                        
                        Image(systemName:"leaf.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("Avocado"))
                            .scaleEffect(CGSize(width: 1, height: leafScale))
                            .clipped()
                            .animation(.easeInOut(duration: 0.3), value: leafScale)
                    }
                }
            }
            
            Section(header: Text(NSLocalizedString("Location", comment: ""))) {
                Picker(NSLocalizedString("Location", comment: ""), selection: $viewModel.location) {
                    ForEach(locations, id: \.self) { location in
                        Text(location.room ?? NSLocalizedString("Unknown", comment: "")).tag(location as Location?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Button(NSLocalizedString("Save_changes", comment: "")) {
                viewModel.saveChanges()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("Avocado"))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .navigationTitle(NSLocalizedString("Plant_profile", comment: ""))
        .onAppear{
            // Resets toggle to current state
            viewModel.statusWater = plant.statusWater
            viewModel.statusFertilizer = plant.statusFertilizer
            
            dropScale = viewModel.statusWater ? 1 : 0
            leafScale = viewModel.statusFertilizer ? 1 : 0
        }
    }
}

/*struct PlantprofileView_Previews: PreviewProvider {
 static var previews: some View {
 PlantprofileView()
 }
 }*/
