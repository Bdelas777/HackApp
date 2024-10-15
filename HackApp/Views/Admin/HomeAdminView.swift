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
            ZStack {
                Color(.systemGray6) // Background color
                    .ignoresSafeArea()

                VStack {
                    if hackData.hacks.isEmpty {
                        if hackData.isLoading {
                            ProgressView("Cargando...")
                                .font(.largeTitle)
                                .padding()
                        } else {
                            Text("No hay hacks disponibles")
                                .font(.largeTitle)
                                .padding()
                                .foregroundColor(.gray)
                        }
                    } else {
                        List(hackData.hacks) { hack in
                            NavigationLink(destination: HackView(hack: hack)) {
                                HackRow(hack: hack)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 3)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .listStyle(PlainListStyle())                    }

                    Spacer()
                }
                .navigationTitle("Tus Hackatons")
                .padding(.bottom, 20)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isActivated = true
                        }  label: {
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
