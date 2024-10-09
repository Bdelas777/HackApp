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
                            get: { calificaciones[selectedEquipo]?[nombreJuez]?[key]?.description ?? "" },
                            set: { input in
                                let score = Double(input.trimmingCharacters(in: .whitespaces)) ?? 0.0
                                if calificaciones[selectedEquipo] == nil {
                                    calificaciones[selectedEquipo] = [:]
                                }
                                if calificaciones[selectedEquipo]?[nombreJuez] == nil {
                                    calificaciones[selectedEquipo]?[nombreJuez] = [:]
                                }
                                calificaciones[selectedEquipo]?[nombreJuez]?[key] = score
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
            initializeCalificaciones()
        }
    }

    private func fetchRubros() {
        print(nombreJuez,"Este es su nombre")
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

    private func submitCalificaciones() {
       
        let rubrosData: [String: [String: [String: Double]]?] = calificaciones
        
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
    GradeView(hackClaveInput: "HACK24", selectedEquipo: "Equipo 1", nombreJuez: "NombreJuez")
}
