//
//  HomeViewAdmin.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 17/04/24.
//
// example
import SwiftUI

struct HomeAdminView: View {
    @StateObject var hackData = HacksViewModel()
    @State var isActivated: Bool = false

    var body: some View {
     
            GeometryReader { geo in
                ZStack {
                    
                    HacksListView()
                    Button {
                        isActivated = true
                    } label: {
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
        
        .sheet(isPresented: $isActivated) {
            AddHackView( listaHacks: hackData)
        }
    }
}

#Preview {
    HomeAdminView()
}
