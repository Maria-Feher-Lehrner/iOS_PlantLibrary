//
//  RegistrationFormView.swift
//  PlantBase
//
//  Created by user on 20.01.25.
//

import SwiftUI
import PhotosUI

struct PlantRegistrationView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) private var presentationMode
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.room, ascending: true)],
        animation: .default
    ) private var locations: FetchedResults<Location>
    
    @StateObject private var viewModel: PlantRegistrationViewModel
    
    @State var profileImageView: Image?;
    
    init() {
        _viewModel = StateObject(wrappedValue: PlantRegistrationViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                VStack{
                    Spacer()
                        .frame(height: 20.0)
                    PhotosPicker(selection: $viewModel.selectedPhoto) {
                        HStack {
                            if viewModel.profileImage != nil {
                                Label("Change Photo", systemImage: "pencil")
                            } else {
                                Label(NSLocalizedString("Change_photo", comment: ""), systemImage: "photo")
                            }
                        }
                    }
                    .onChange(of: viewModel.selectedPhoto) { newItem in
                        Task {
                            await viewModel.processSelectedPhoto()
                        }
                    }
                    
                    VStack {
                        if let image = viewModel.profileImage {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                        } else {
                            Image("Profile")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                        }
                    }
                    
                    /*Spacer()
                     .frame(height: 40.0)*/
                    profileImageView?
                        .resizable()
                        .scaledToFit()
                    
                    TextField(NSLocalizedString("Name", comment: ""), text: $viewModel.inputGivenName)
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(Color("Avocado"))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    TextField(NSLocalizedString("Botanical_name", comment: ""), text: $viewModel.inputBotanicalName)
                        .foregroundColor(Color("Avocado"))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                    .frame(height: 20.0)
                
                VStack{
                    Text(NSLocalizedString("Light", comment: ""))
                    Picker(selection: $viewModel.selectInputRequirementLight, label: Text(NSLocalizedString("Light", comment: ""))){
                        Text(NSLocalizedString("low", comment: "")).tag(1)
                        Text(NSLocalizedString("m-low", comment: "")).tag(2)
                        Text(NSLocalizedString("m-high", comment: "")).tag(3)
                        Text(NSLocalizedString("high", comment: "")).tag(4)
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack{
                    Text(NSLocalizedString("Water", comment: ""))
                    Picker(selection: $viewModel.selectInputRequirementWater, label: Text(NSLocalizedString("Water", comment: ""))){
                        Text(NSLocalizedString("2/w", comment: "")).tag(3)
                        Text(NSLocalizedString("1/w", comment: "")).tag(2)
                        Text(NSLocalizedString("0.5/w", comment: "")).tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack{
                    Text(NSLocalizedString("Fertilizer", comment: ""))
                    Picker(selection: $viewModel.selectInputRequirementFertilizer, label: Text(NSLocalizedString("Fertilizer", comment: ""))){
                        Text(NSLocalizedString("2/m", comment: "")).tag(3)
                        Text(NSLocalizedString("1/m", comment: "")).tag(2)
                        Text(NSLocalizedString("0.5/m", comment: "")).tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack{
                    Text(NSLocalizedString("Location", comment: ""))
                    Picker("Select Location", selection: $viewModel.selectedLocation) {
                        ForEach(locations, id: \.self) { location in
                            Text(location.room ?? "Unknown Room").tag(location as Location?)
                        }
                    }
                    .onAppear {
                        if viewModel.selectedLocation == nil, let firstLocation = locations.first {
                            viewModel.selectedLocation = firstLocation
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 20.0)
                
                Button(NSLocalizedString("Save", comment: "")){
                    viewModel.savePlant()
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("Avocado"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(viewModel.selectedLocation == nil)
            }
            .padding()
            .onChange(of: viewModel.selectedPhoto) { newItem in
                Task {
                    /*guard let imageData = try? await newItem?.loadTransferable(type: Data.self) else {
                     return
                     }
                     profileImageView = Image(uiImage: UIImage(data: imageData)!)*/
                    await viewModel.processSelectedPhoto()
                }
            }
        }
    }
}

struct RegistrationFormView_Previews: PreviewProvider {
    static var previews: some View {
        PlantRegistrationView()
    }
}
