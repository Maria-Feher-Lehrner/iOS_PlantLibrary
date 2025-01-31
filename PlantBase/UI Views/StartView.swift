//
//  ContentView.swift
//  PlantBase
//
//  Created by user on 20.01.25.
//

import SwiftUI
import CoreData

struct StartView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView{
            VStack(spacing: 18) {
                Image("Title")
                    .padding(.vertical)
                Text("TITLE")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(Color("Fern Green"))
                Text(NSLocalizedString("Subtitle", comment: ""))
                    .fontWeight(.bold)
                    .foregroundColor(Color("Cafe noir"))
                Spacer()
                    .frame(height: 10.0)
                
                VStack{
                    Text(NSLocalizedString("Check_blooms", comment: ""))
                    NavigationLink(destination: PlantsView(context: viewContext)) {
                        Text(NSLocalizedString("Plant_catalogue", comment: ""))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Sage"))
                            .foregroundColor(Color("Cafe noir"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                VStack{
                    Text(NSLocalizedString("New_Plant", comment: ""))
                    NavigationLink(destination: PlantRegistrationView()) {
                        Text(NSLocalizedString("Add", comment: ""))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Sage"))
                            .foregroundColor(Color("Cafe noir"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                VStack{
                    Text(NSLocalizedString("Location_prompt", comment: ""))
                    NavigationLink(destination: LocationsView()) {
                        Text(NSLocalizedString("Locations", comment: ""))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Sage"))
                            .foregroundColor(Color("Cafe noir"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                //*****FOR TESTING PURPOSE: COMMENT IN THIS SECTION TO TRIGGER NOTIFICATIONS MANUALLY!*****
                /*
                Button("Send Test Notification 'Water' in 5 Sec") {
                    NotificationDelegate().scheduleWateringNotifications(for: 0)
                }
                Button("Send Test Notification 'Fertilizer' in 5 Sec") {
                    NotificationDelegate().scheduleFertilizerNotifications(for: 0)
                }*/
                
                
            }
            .navigationTitle("Home")
        }
    }
}

struct Previews_StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
