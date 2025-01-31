//
//  LocationRegistrationView.swift
//  PlantBase
//
//  Created by user on 20.01.25.
//

import SwiftUI

struct LocationsView: View {
    @ObservedObject private var viewModel = LocationsViewModel()
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        entity: Location.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.room, ascending: true)]
    ) private var locations: FetchedResults<Location>
    
    var body: some View {
        VStack {
            // List of existing locations
            List(locations, id: \.id) { location in
                NavigationLink(destination: LocationDetailView(location: location)) {
                    VStack(alignment: .leading) {
                        Text(location.room ?? "Unknown Room")
                            .font(.headline)
                        Text(location.position ?? "Unknown Position")
                            .font(.subheadline)
                        if let light = location.light {
                            Text("Light Intensity: \(localizedLightIntensity(Int(light.intensityLight)))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Button to add a new location
            NavigationLink(destination: LocationDetailView(location: nil)) {
                Text(NSLocalizedString("Add_Location", comment: ""))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("Avocado"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Locations")
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
    }
}
