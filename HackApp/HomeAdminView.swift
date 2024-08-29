//
//  HomeViewAdmin.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 17/04/24.
//

import SwiftUI

struct HomeAdminView: View {
    let dummyData = ["Hack 1", "Hack 2", "Hack 3", "Hack 4", "Hack 5", "Hack 6","Hack 7", "Hack 8", "Hack 9" ]
    @StateObject var hackData = HackViewModel()
    @State var isActivated : Bool = false
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                ZStack{
                    List{
                        ForEach(hackData.hackList, id: \.self){data in
                            NavigationLink(destination: ContentView()){
                                Text(data.nombre)
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .padding()
                            }
                        }
                    }
                    .listRowSpacing(10)
                    Button{
                        isActivated = true
                    }label: {
                        Label("Nuevo Hackathon", systemImage: "plus")
                            .font(.title)
                            .bold()
                            .padding()
                    }
                    .buttonStyle(MainViewButtonStyle())
                    .offset(x: geo.size.width / 3.8, y: geo.size.height / 2.5)
                }
            }
            .navigationTitle("Tus Hackatons")
        }
        .sheet(isPresented: $isActivated){
            AddHackView(listaHacks: hackData)
        }
    }
}

#Preview {
    HomeAdminView()
}
