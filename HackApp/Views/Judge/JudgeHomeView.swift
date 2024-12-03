//
//  JudgeHomeView.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 01/05/24.
//
import SwiftUI
/// Vista para que los jueces puedan seleccionar un hackathon y luego elegir su nombre de juez para calificar.
///
/// Esta vista permite a los jueces ingresar la clave de un hackathon y, si el hackathon existe, mostrar la lista de jueces
/// disponibles. El juez puede seleccionar su nombre de la lista y, posteriormente, acceder a su vista de calificación.
/// **Características**:
/// - Permite al usuario ingresar la clave de un hackathon para buscar los jueces disponibles.
/// - Si la clave es válida, muestra los jueces en una lista y permite que el usuario seleccione uno.
/// - Si se selecciona un juez, el botón "Presiona aquí, para comenzar a calificar" habilita el acceso a la vista de calificación.
/// - Si no se encuentran resultados (hackathon o jueces), muestra un mensaje de error.
struct JudgeHomeView: View {
    let hackClaveInput: String
    let selectedJudge: String
    let nombreHack: String
    let isActive: Bool
    @State private var selectedEquipos: [String]?
    @State private var equiposEvaluados: [String: Bool] = [:]
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
        viewModel.getEquipos(for: hackClaveInput) { result in
            switch result {
            case .success(let equipos):
                selectedEquipos = equipos.isEmpty ? nil : equipos
            case .failure:
                selectedEquipos = nil
            }
        }
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
