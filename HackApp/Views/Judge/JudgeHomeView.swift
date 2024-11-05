//
//  JudgeHomeView.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 01/05/24.
//
import SwiftUI

struct JudgeHomeView: View {
    let hackClaveInput: String
    let selectedJudge: String
    let nombreHack: String
    let isActive: Bool
    @State private var selectedEquipos: [String]?
    @State private var equiposEvaluados: [String: Bool] = [:]  // Diccionario que guarda si el equipo está calificado o no
    @ObservedObject var viewModel = HacksViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                // Título principal con un subtítulo informativo
                Text("Hackathon: \(nombreHack)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("Equipos participantes")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)

                // Lista de equipos
                if let equipos = selectedEquipos, !equipos.isEmpty {
                    List {
                        ForEach(equipos, id: \.self) { equipo in
                            HStack {
                                // Icono indicando si el equipo está calificado
                                Image(systemName: equiposEvaluados[equipo] == true ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(equiposEvaluados[equipo] == true ? .green : .gray)
                                    .padding(.leading)

                                // Nombre del equipo
                                Text(equipo)
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .padding(.vertical)
                                    .foregroundColor(.primary)

                                Spacer()

                                // Etiqueta si ya está calificado
                                if equiposEvaluados[equipo] == true {
                                    Text("Calificado")
                                        .font(.footnote)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(UIColor.systemGray6)))
                            .shadow(radius: 5)
                            .padding(.vertical, 5)
                            .background(
                                NavigationLink(
                                    destination: GradeView(
                                        hackClaveInput: hackClaveInput,
                                        selectedEquipo: equipo,
                                        nombreJuez: selectedJudge,
                                        isActive: isActive)
                                ) {
                                    EmptyView() // EmptyView acts as a trigger for NavigationLink without altering layout
                                }
                                .opacity(0) // Hide the NavigationLink visual element
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    // Si no hay equipos disponibles
                    Text("No hay equipos disponibles para evaluar.")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
            }
            .padding()
            .navigationTitle("Equipos de \(nombreHack)")
            .onAppear {
                fetchEquipos()
            }
        }
    }

   
    private func fetchEquipos() {
        // Primero obtenemos los equipos para este hack
        viewModel.getEquipos(for: hackClaveInput) { result in
            switch result {
            case .success(let equipos):
                selectedEquipos = equipos.isEmpty ? nil : equipos
            case .failure:
                selectedEquipos = nil // Manejo de errores
            }
        }

        // Luego, verificamos si los equipos han sido calificados por el juez
        viewModel.fetchHackAndEvaluateTeams(for: hackClaveInput, selectedJudge: selectedJudge) { result in
            switch result {
            case .success(let equiposEvaluadosDict):
                self.equiposEvaluados = equiposEvaluadosDict // Actualizamos el diccionario con los resultados
            case .failure:
                self.equiposEvaluados = [:]  // En caso de error, reseteamos el estado
            }
        }
    }
}

struct JudgeHomeView_Previews: PreviewProvider {
    static var previews: some View {
        JudgeHomeView(hackClaveInput: "HACK24", selectedJudge: "Juez1", nombreHack:"Ejemplo Hackathon", isActive: false)
    }
}
