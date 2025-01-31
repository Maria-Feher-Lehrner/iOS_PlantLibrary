//
//  PlantsView.swift
//  PlantBase
//
//  Created by user on 23.01.25.
//

import SwiftUI
import CoreData

struct PlantsView: View {
    
    @ObservedObject private var viewModel: PlantsViewModel
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        entity: Plant.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Plant.givenName, ascending: true)]
    ) private var plants: FetchedResults<Plant>
    
    init(context: NSManagedObjectContext) {
        self.viewModel = PlantsViewModel(context: context)
    }
    
    var body: some View {
        
        VStack {
            Text(NSLocalizedString("Leafy_Friend", comment: ""))
                .font(.title)
                .foregroundColor(Color("Fern Green"))
            
            List(plants, id: \.id) { plant in
                NavigationLink(destination: PlantprofileView(plant: plant)) {
                    HStack{
                        VStack(alignment: .leading) {
                            Text(plant.givenName ?? NSLocalizedString("Anonymous", comment: ""))
                                .font(.headline)
                            
                            // Safely access the location's room
                            if let room = plant.location?.room {
                                Text(room)
                                    .font(.subheadline)
                            } else {
                                Text(NSLocalizedString("Unknown", comment: ""))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            // Water Icon
                            Image(systemName: plant.statusWater ? "drop.fill" : "drop")
                                .foregroundColor(Color("Water blue"))
                            
                            // Fertilizer Icon
                            Image(systemName: plant.statusFertilizer ? "leaf.fill" : "leaf")
                                .foregroundColor(Color("Avocado"))
                            
                            // Light Icon
                            let lightMatch = viewModel.doesLightMatch(plant: plant)
                            Image(systemName: lightMatch ? "sun.max.fill" : "sun.max")
                                .foregroundColor(lightMatch ? .yellow : .gray)
                        }
                        
                    }
                }
            }
            
            
        }
    }
}

/*struct PlantsView_Previews: PreviewProvider {
    static var previews: some View {
        PlantsView()
    }
}
*/
