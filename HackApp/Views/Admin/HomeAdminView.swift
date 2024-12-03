//
//  HomeViewAdmin.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 17/04/24.
//
// example
import SwiftUI
/// Vista principal del administrador de Hackathons.
///
/// Esta vista muestra una lista de hackathons disponibles para el administrador. Si no hay hackathons disponibles,
/// se muestra un mensaje indicando que no hay datos. Si se encuentran hackathons, estos se presentan en una cuadrícula.
/// Además, hay un botón flotante que permite al administrador crear un nuevo hackathon.
///
/// **Propiedades**:
/// - `hackData`: Un `HacksViewModel` que maneja los datos de los hackathons.
/// - `isActivated`: Estado que controla la presentación de la vista para agregar un nuevo hackathon.

struct HomeAdminView: View {
    @EnvironmentObject var hackData: HacksViewModel
    @State var isActivated: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
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
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(hackData.hacks) { hack in
                                NavigationLink(destination: HackView(hack: hack)) {
                                    HackRow(hack: hack)
                                        .environmentObject(hackData)

                                }
                            }
                        }
                        .padding()
                    }

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
