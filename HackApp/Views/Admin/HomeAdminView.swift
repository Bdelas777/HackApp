//
//  HomeViewAdmin.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 17/04/24.
//
// example
import SwiftUI

struct HomeAdminView: View {
    @StateObject var hackData = HackViewModel()
    @State var isActivated: Bool = false

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    List {
                        ForEach(hackData.hackList, id: \.id) { hack in
                            NavigationLink(destination: ContentView(selectedHack: hack)) {
                                Text(hack.nombre)
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .padding()
                            }
                        }
                    }
                    .listRowSpacing(10)
                    
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
        }
        .sheet(isPresented: $isActivated) {
            AddHackView( listaHacks: hackData)
        }
    }
}

#Preview {
    HomeAdminView()
}
