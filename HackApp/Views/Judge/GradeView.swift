//
//  GradeView.swift
//  HackApp
//
//  Created by Alumno on 02/10/24.
//

import SwiftUI

struct GradeView: View {
    let hackClaveInput: String
    @State private var rubros: [String: String] = [:] 
    @ObservedObject var viewModel = HacksViewModel()

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
                            get: { rubros[key] ?? "" },
                            set: { rubros[key] = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                    }
                    .padding()
                }
            }
            
            Button(action: {
                // Lógica para calificar
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
        }
    }

    private func fetchRubros() {
        viewModel.fetchRubros(for: hackClaveInput) { result in
            switch result {
            case .success(let rubrosData):
                print("Datos de rubros obtenidos: \(rubrosData)") //
                self.rubros = rubrosData.mapValues {
                    String($0)
                }
                print("Rubros después de la asignación: \(self.rubros)")
            case .failure(let error):
                print("Error al obtener rubros: \(error)")
            }
        }
    }

    private func submitCalificaciones() {
        print("Calificaciones enviadas: \(rubros)")
    }
}

#Preview {
    GradeView(hackClaveInput: "HACK24")
}
