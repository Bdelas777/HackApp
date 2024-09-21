//
//  HackListView.swift
//  HackApp
//
//  Created by Alumno on 19/09/24.
//
import SwiftUI

struct HacksListView: View {
    @ObservedObject var viewModel = HacksViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.hacks) { hack in
                HStack {
                    VStack(alignment: .leading) {
                        Text(hack.nombre)
                            .font(.headline)
                        Text("Equipos: \(hack.equipos.joined(separator: ", "))")
                            .font(.subheadline)
                        Text("Está Activo: \(hack.estaActivo ? "Sí" : "No")")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Hackathons")
            .onAppear {
                viewModel.fetchHacks()
            }
        }
    }
}

struct HacksListView_Previews: PreviewProvider {
    static var previews: some View {
        HacksListView()
    }
}
