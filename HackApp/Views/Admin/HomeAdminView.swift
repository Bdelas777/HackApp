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
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    VStack {
                        if hackData.hacks.isEmpty {
                            if hackData.isLoading {
                                Text("Cargando...")
                                    .font(.largeTitle)
                                    .padding()
                            } else {
                                Text("No hay hacks disponibles")
                                    .font(.largeTitle)
                                    .padding()
                            }
                        } else {
                            List(hackData.hacks) { hack in
                                NavigationLink(destination: HackView(hack: hack)) {
                                    HackRow(hack: hack)
                                }
                            }
                        }
                        
                        Spacer() // Pushes content above
                    }
                    .navigationTitle("Tus Hackatons")
                    
                    // Button positioned at bottom right
                    VStack {
                        Spacer() // Pushes the button to the bottom
                        HStack {
                            Spacer() // Pushes the button to the right
                            Button {
                                isActivated = true
                            } label: {
                                Label("Nuevo Hackathon", systemImage: "plus")
                                    .font(.title)
                                    .bold()
                                    .padding()
                            }
                            .buttonStyle(MainViewButtonStyle())
                            .padding()
                        }
                    }
                }
            }
            .sheet(isPresented: $isActivated) {
                AddHackView(listaHacks: hackData)
            }
        }
        .onAppear {
            hackData.fetchHacks()
        }
    }
}

#Preview {
    HomeAdminView()
}
