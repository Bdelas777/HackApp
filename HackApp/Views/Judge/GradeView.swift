

import SwiftUI

struct GradeView: View {
    let hackClaveInput: String
    let selectedEquipo: String
    let nombreJuez: String
    @State private var valorRubro: Double = 0.0
    @State private var rubros: [String: Double] = [:]
    @ObservedObject var viewModel = HacksViewModel()
    @State private var calificaciones: [String: [String: [String: Double]]] = [:]
    @Environment(\.dismiss) var dismiss
    @State private var alreadyRated = false
    @State private var showAlert = false  // Para controlar la alerta
    @State private var alertMessage = ""  // El mensaje de la alerta
    let isActive: Bool

    var body: some View {
        VStack {
            if !isActive {
                Text("El hackathon ha cerrado. No se puede calificar.")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(12)
                    .padding(.horizontal)
            } else {
                Text("Calificación de \(selectedEquipo)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(.primary)

                Text("Rubros de evaluación")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)

                if alreadyRated {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title)
                        Text("Ya has calificado este equipo.")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.2)))
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(rubros.keys.sorted(), id: \.self) { key in
                                VStack(spacing: 16) {
                                    HStack {
                                        Text(key)
                                            .font(.headline)
                                            .font(.system(size: 20))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundColor(.primary)
                                        
                                        Text("\(calificaciones[selectedEquipo]?[nombreJuez]?[key] ?? 1.0, specifier: "%.1f")")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    // Slider
                                    Slider(value: Binding(
                                        get: {
                                            calificaciones[selectedEquipo]?[nombreJuez]?[key] ?? 1.0
                                        },
                                        set: { newValue in
                                            let score = min(max(newValue, 1), valorRubro)
                                            calificaciones[selectedEquipo, default: [:]][nombreJuez, default: [:]][key] = score
                                        }
                                    ), in: 1...valorRubro, step: 1)
                                    .accentColor(.blue)
                                    .padding(.horizontal)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray5)))
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                }
                                .padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(UIColor.systemGroupedBackground)))
                                .shadow(radius: 5)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    
                    Button(action: {
                        checkForEmptyScores()
                    }) {
                        Text("Calificar")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .font(.system(size: 20))
                            .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .padding(.top)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .onAppear {
            fetchValorRubro()
            fetchRubros()
            initializeCalificaciones()
            checkAlreadyRated()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirmación"),
                message: Text(alertMessage),
                primaryButton: .default(Text("Confirmar"), action: {
                    submitCalificaciones()
                }),
                secondaryButton: .cancel()
            )
        }
    }

    private func fetchRubros() {
        viewModel.fetchRubros(for: hackClaveInput) { result in
            switch result {
            case .success(let rubrosData):
                self.rubros = rubrosData
            case .failure(let error):
                print("Error al obtener rubros: \(error)")
            }
        }
    }

    private func fetchValorRubro() {
        viewModel.getValorRubro(for: hackClaveInput) { result in
            switch result {
            case .success(let valor):
                self.valorRubro = valor
                print("Valor del Rubro: \(valor)")
            case .failure(let error):
                print("Error al obtener el valor del rubro: \(error)")
            }
        }
    }

    private func initializeCalificaciones() {
        calificaciones[selectedEquipo] = [:]
        for key in rubros.keys {
            calificaciones[selectedEquipo]?[nombreJuez] = [:]
            calificaciones[selectedEquipo]?[nombreJuez]?[key] = 1.0 // Inicializa a 1.0
        }
    }

    private func checkAlreadyRated() {
        viewModel.getCalificacionesJuez(for: selectedEquipo, judgeName: nombreJuez, hackClave: hackClaveInput) { result in
            switch result {
            case .success(let calif):
                alreadyRated = calif != nil
            case .failure(let error):
                print("Error al verificar calificaciones: \(error)")
            }
        }
    }

    // Verifica si algún rubro está en 1 y muestra la alerta
    private func checkForEmptyScores() {
        var allScoresAreValid = true
        for (key, value) in calificaciones[selectedEquipo]?[nombreJuez] ?? [:] {
            if value == 1.0 {
                allScoresAreValid = false
                alertMessage = "El valor de \(key) sigue siendo 1.0. ¿Estás seguro de querer asignar esta calificación?"
                break
            }
        }

        if allScoresAreValid {
            submitCalificaciones() // Si todas las calificaciones son válidas, enviamos
        } else {
            showAlert = true // Muestra la alerta si algún rubro sigue en 1.0
        }
    }

    private func submitCalificaciones() {
        let rubrosData: [String: [String: [String: Double]]?] = calificaciones
        
        viewModel.saveCalificaciones(for: hackClaveInput, calificaciones: rubrosData) { result in
            switch result {
            case .success:
                dismiss()
            case .failure(let error):
                print("Hubo un error")
            }
        }
    }
}

#Preview {
    GradeView(hackClaveInput: "HACK24", selectedEquipo: "Equipo 1", nombreJuez: "NombreJuez", isActive: true)
}
