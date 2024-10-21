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
                infoSection(title: "Clave:", content: hack.clave)
                infoSection(title: "Nombre:", content: hack.nombre)
                infoSection(title: "Descripción:", content: hack.descripcion)
                infoSection(title: "Fecha Inicio:", content: formattedDate(hack.FechaStart))
                infoSection(title: "Fecha Fin:", content: formattedDate(hack.FechaEnd))
                infoSection(title: "Estes el valor del rubro:", content: String(hack.valorRubro))
                infoSection(title: "Estado:", content: hack.estaActivo ? "Activo" : "Inactivo", isStatus: true)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
            .padding()

            Divider()

            VStack {
                Text("Equipos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom)

                NavigationLink(destination: ResultsView(hack: hack)) {
                    Text("Ver Resultados")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)

                List {
                    if let equipos = selectedEquipos, !equipos.isEmpty {
                        ForEach(equipos, id: \.self) { equipo in
                            NavigationLink(destination: TeamView(hack: hack, equipoSeleccionado: equipo)) {
                                Text(equipo)
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
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
            .padding(.bottom)
        }
        .navigationTitle("Detalles del Hackathon")
        .onAppear {
            fetchEquipos()
        }
    }

    private func infoSection(title: String, content: String, isStatus: Bool = false) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(content)
                .font(.title2)
                .fontWeight(isStatus ? .bold : .regular)
                .foregroundColor(isStatus && content == "Activo" ? .green : (isStatus ? .red : .primary))
        }
        .padding(.bottom, 5)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    private func fetchEquipos() {
        viewModel.getEquipos(for: hack.clave) { result in
            switch result {
            case .success(let equipos):
                selectedEquipos = equipos.isEmpty ? nil : equipos
                if let equipos = selectedEquipos {
                    for equipo in equipos {
                        fetchAndCalculateScores(for: equipo, hackClave: hack.clave, valorRubro: hack.valorRubro)
                    }
                }
            case .failure:
                selectedEquipos = nil
            }
        }
    }

    private func fetchAndCalculateScores(for equipo: String, hackClave: String, valorRubro: Int) { // Asegúrate de incluir valorRubro como parámetro
        viewModel.fetchAndCalculateScores(for: equipo, hackClave: hackClave, valorRubro: valorRubro) { result in
            switch result {
            case .success(let totalScore):
                print("Puntuación total para \(equipo): \(totalScore)")
            case .failure(let error):
                print("Error al calcular la puntuación: \(error)")
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
        FechaStart: Date(),
        FechaEnd: Date(),
        valorRubro: 5
    ))
}
