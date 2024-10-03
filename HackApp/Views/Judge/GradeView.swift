//
//  GradeView.swift
//  HackApp
//
//  Created by Alumno on 02/10/24.
//

import SwiftUI

struct GradeView: View {
    let hackClaveInput: String
    let selectedEquipo: String // New property to hold the selected equipo
    @State private var rubros: [String: String] = [:]
    @ObservedObject var viewModel = HacksViewModel()
    @State private var calificaciones: [String: [String: [Int]]] = [:]

    var body: some View {
        VStack {
            VStack {
                Text("Rubros de evaluación")
                    .font(.headline)
                    .padding()

                ForEach(rubros.keys.sorted(), id: \.self) { key in
                    HStack {
                        Text(key)
                        TextField("Calificación", text: Binding(
                            get: { calificaciones[selectedEquipo]?[key]?.map(String.init).joined(separator: ", ") ?? "" },
                            set: { input in
                                let scores = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                                calificaciones[selectedEquipo, default: [:]][key] = scores
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                    }
                    .padding()
                }
            }

            Button(action: {
                submitCalificaciones()
            }) {
                Text("Calificar")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            fetchRubros()
            initializeCalificaciones() // Initialize calificaciones when the view appears
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
            calificaciones[selectedEquipo]?[rubro] = []
        }
    }

    private func submitCalificaciones() {
        let rubrosData = calificaciones
        
        viewModel.saveCalificaciones(for: hackClaveInput, calificaciones: rubrosData) { result in
            switch result {
            case .success:
                print("Calificaciones guardadas exitosamente.")
            case .failure(let error):
                print("Error al guardar calificaciones: \(error)")
            }
        }
    }
}

#Preview {
    GradeView(hackClaveInput: "HACK24", selectedEquipo: "Equipo 1")
}
