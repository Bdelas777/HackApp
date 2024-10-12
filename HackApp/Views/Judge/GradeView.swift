//
//  GradeView.swift
//  HackApp
//
//  Created by Alumno on 02/10/24.
//
import SwiftUI

struct GradeView: View {
    let hackClaveInput: String
    let selectedEquipo: String
    let nombreJuez: String
    @State private var rubros: [String: String] = [:]
    @ObservedObject var viewModel = HacksViewModel()
    @State private var calificaciones: [String: [String: [String: Double]]] = [:]
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alreadyRated = false

    var body: some View {
        VStack {
            Text("Rubros de evaluación")
                .font(.headline)
                .padding()

            if alreadyRated {
                Text("Ya has calificado este equipo.")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding()
            } else {
                ForEach(rubros.keys.sorted(), id: \.self) { key in
                    HStack {
                        Text(key)
                            .frame(width: 150, alignment: .leading)
                        
                        TextField("Calificación", text: Binding(
                            get: {
                                let score = calificaciones[selectedEquipo]?[nombreJuez]?[key] ?? 0.0
                                return score == 0 ? "" : String(score)
                            },
                            set: { input in
                                let score = Double(input.trimmingCharacters(in: .whitespaces)) ?? 0.0
                                if score < 0 || score > 100 {
                                    alertMessage = "La calificación debe estar entre 0 y 100."
                                    showAlert = true
                                } else {
                                    if calificaciones[selectedEquipo] == nil {
                                        calificaciones[selectedEquipo] = [:]
                                    }
                                    if calificaciones[selectedEquipo]?[nombreJuez] == nil {
                                        calificaciones[selectedEquipo]?[nombreJuez] = [:]
                                    }
                                    calificaciones[selectedEquipo]?[nombreJuez]?[key] = score
                                }
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                    }
                    .padding(.vertical, 8)
                }

                Button(action: {
                    submitCalificaciones()
                }) {
                    Text("Calificar")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alreadyRated ? "Éxito" : "Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("Aceptar"))
            )
        }
        .onAppear {
            fetchRubros()
            initializeCalificaciones()
            checkAlreadyRated()
        }
    }

    private func fetchRubros() {
        viewModel.fetchRubros(for: hackClaveInput) { result in
            switch result {
            case .success(let rubrosData):
                self.rubros = rubrosData.mapValues { String($0) }
            case .failure(let error):
                print("Error al obtener rubros: \(error)")
            }
        }
    }

    private func initializeCalificaciones() {
        calificaciones[selectedEquipo] = [:]
        for rubro in rubros.keys {
            calificaciones[selectedEquipo]?[nombreJuez] = [:]
        }
    }

    private func checkAlreadyRated() {
        viewModel.getCalificacionesJuez(for: selectedEquipo, judgeName: nombreJuez, hackClave: hackClaveInput) { result in
            switch result {
            case .success(let calif):
                alreadyRated = calif != nil // Verifica si hay calificaciones para el juez
            case .failure(let error):
                print("Error al verificar calificaciones: \(error)")
            }
        }
    }


    private func submitCalificaciones() {
        let rubrosData: [String: [String: [String: Double]]?] = calificaciones
        
        viewModel.saveCalificaciones(for: hackClaveInput, calificaciones: rubrosData) { result in
            switch result {
            case .success:
                alertMessage = "Calificaciones guardadas exitosamente."
                showAlert = true
                alreadyRated = true
            case .failure(let error):
                alertMessage = "Error al guardar calificaciones: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

#Preview {
    GradeView(hackClaveInput: "HACK24", selectedEquipo: "Equipo 1", nombreJuez: "NombreJuez")
}
