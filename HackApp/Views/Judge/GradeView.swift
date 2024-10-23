import SwiftUI

struct GradeView: View {
    let hackClaveInput: String
    let selectedEquipo: String
    let nombreJuez: String
    @State private var valorRubro: Double = 0.0
    @State private var rubros: [String: Double] = [:]
    @ObservedObject var viewModel = HacksViewModel()
    @State private var calificaciones: [String: [String: [String: Double]]] = [:]
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alreadyRated = false

    var body: some View {
        VStack {
            Text("Rubros de evaluación")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            if alreadyRated {
                Text("Ya has calificado este equipo.")
                    .font(.title3)
                    .foregroundColor(.green)
                    .padding()
            } else {
                ForEach(rubros.keys.sorted(), id: \.self) { key in
                    VStack(spacing: 16) {
                        HStack {
                            Text(key)
                                .font(.headline)
                                .font(.system(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(calificaciones[selectedEquipo]?[nombreJuez]?[key] ?? 1.0, specifier: "%.1f")")
                                .font(.headline)
                                .frame(width: 50)
                        }

                        VStack {
                            // Slider estilizado
                            VStack {
                                Slider(value: Binding(
                                    get: {
                                        calificaciones[selectedEquipo]?[nombreJuez]?[key] ?? 1.0
                                    },
                                    set: { newValue in
                                        let score = min(max(newValue, 1), valorRubro)
                                        calificaciones[selectedEquipo, default: [:]][nombreJuez, default: [:]][key] = score
                                    }
                                ), in: 1...valorRubro, step: 0.5) // Permitir movimiento en 0.5
                                .accentColor(.blue)
                                .padding(.horizontal)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray5)))
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                
                                // Línea de referencia
                                HStack {
                                    ForEach(1..<Int(valorRubro) + 1, id: \.self) { value in
                                        Spacer()
                                        Text("\(value)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, -10)
                            }

                            // Etiqueta de valor del slider
                            Text("Valor actual: \(calificaciones[selectedEquipo]?[nombreJuez]?[key] ?? 1.0, specifier: "%.1f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.top, 4)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding(.vertical, 12)
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
                        .font(.system(size: 20))
                        .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .padding(.top)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alreadyRated ? "Éxito" : "Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("Aceptar"))
            )
        }
        .onAppear {
            fetchValorRubro()
            fetchRubros()
            initializeCalificaciones()
            checkAlreadyRated()
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
