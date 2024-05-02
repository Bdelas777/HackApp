//
//  HomeViewAdmin.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 17/04/24.
//

import SwiftUI

struct HomeAdminView: View {
    let dummyData = ["Elemento 1", "Elemento 2", "Elemento 3", "Elemento 4", "Elemento 5", "Elemento 6","Elemento 7", "Elemento 8", "Elemento 9" ]
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                ZStack{
                    List{
                        ForEach(dummyData, id: \.self){data in
                            NavigationLink(destination: ContentView()){
                                Text(data)
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .padding()
                            }
                        }
                    }
                    .listRowSpacing(10)
                    Button{
                        
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
    }
}

#Preview {
    HomeAdminView()
}
