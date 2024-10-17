//
//  HackView.swift
//  HackApp
//
//  Created by Alumno on 24/09/24.
//

import SwiftUI

struct HackView: View {
    var hack: HackPrueba
    @State private var selectedEquipos: [String]?
    @ObservedObject var viewModel = HacksViewModel()

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Clave:")
                    .font(.headline)
                Text(hack.clave)
                    .font(.title2)
                    .padding(.bottom)

                Text("Nombre:")
                    .font(.headline)
                Text(hack.nombre)
                    .font(.title2)
                    .padding(.bottom)

                Text("Descripción:")
                    .font(.headline)
                Text(hack.descripcion)
                    .font(.body)
                    .padding(.bottom)

                Text("Fecha:")
                    .font(.headline)
                Text("\(hack.Fecha, style: .date)")
                    .font(.title2)
                    .padding(.bottom)

                Text("Estado:")
                    .font(.headline)
                Text(hack.estaActivo ? "Activo" : "Inactivo")
                    .font(.title2)
                    .foregroundColor(hack.estaActivo ? .green : .red)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
            .padding()
            
            Divider()

            Text("Equipos")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            
            NavigationLink(destination: ResultsView(hack: hack)) {
                Text("Ver Resultados")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            List {
                if let equipos = selectedEquipos, !equipos.isEmpty {
                    ForEach(equipos, id: \.self) { equipo in
                        NavigationLink(destination: TeamView(hack: hack, equipoSeleccionado: equipo)) {
                            Text(equipo)
                                .font(.title2)
                                .fontWeight(.medium)
                                .padding()
                        }
                    }
                } else {
                    Text("No hay equipos disponibles.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Detalles del Hackathon")
        .onAppear {
            fetchEquipos()
        }
    }

    private func fetchEquipos() {
        viewModel.getEquipos(for: hack.clave) { result in
            switch result {
            case .success(let equipos):
                selectedEquipos = equipos.isEmpty ? nil : equipos
                if let equipos = selectedEquipos {
                    for equipo in equipos {
                        fetchAndCalculateScores(for: equipo, hackClave: hack.clave)
                    }
                }
            case .failure:
                selectedEquipos = nil
            }
        }
    }

    private func fetchAndCalculateScores(for equipo: String, hackClave: String) {
        viewModel.fetchAndCalculateScores(for: equipo, hackClave: hackClave) { result in
            switch result {
            case .success(let totalScore):
                print("Puntuación total para \(equipo): \(totalScore)")
                // Puedes actualizar la UI o mostrar un mensaje si lo deseas
            case .failure(let error):
                print("Error al calcular la puntuación: \(error)")
                // Manejar el error si es necesario
            }
        }
    }
}

#Preview {
    HackView(hack: HackPrueba(
        id: "Ejemplo Hack",
        clave: "Hack",
        descripcion: "Descripción del hack",
        equipos: [],
        jueces: [],
        rubros: [:],
        estaActivo: true,
        nombre: "Ejemplo",
        tiempoPitch: 29,
        Fecha: Date()
    ))
}
