import SwiftUI

struct GradeView: View {
    let hackClaveInput: String
    let selectedEquipo: String
    let nombreJuez: String
    @State private var valorRubro: Double = 0.0
    @State private var rubros: [String: Double] = [:]
    @State private var calificaciones: [String: [String: [String: Double]]] = [:]
    @State private var notas: String = ""
    @State private var alreadyRated = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showConfirmationAlert = false
    @State private var judgeNotes: String = ""
    @State private var calificacionesPrevias: [String: Double]? = nil
    @Environment(\.dismiss) var dismiss
    let isActive: Bool
    @ObservedObject var viewModel = HacksViewModel()
    @State private var isNotesExpanded: Bool = false  // Variable para controlar el Toggle de notas

    var body: some View {
        ScrollView {  // Agregar ScrollView para hacer la vista desplazable
            VStack(spacing: 24) {
                if !isActive {
                    Text("El hackathon ha cerrado. No se puede calificar.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(16)
                        .shadow(radius: 10)
                        .padding(.horizontal)
                } else {
                    // Título principal
                    Text("Calificación de \(selectedEquipo)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top)

                    Text("Rubros de evaluación")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 12)
                    
                    // Sección de calificaciones previas
                    if alreadyRated {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title)
                                Text("Ya has calificado este equipo.")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            
                            // Desglose de calificaciones previas
                            VStack(alignment: .center, spacing: 16) {
                                Text("Desglose de calificaciones:")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
                                    .cornerRadius(16)
                                    .shadow(radius: 10)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                
                                if let calificacionesPrevias = calificacionesPrevias {
                                    VStack(spacing: 12) {
                                        ForEach(calificacionesPrevias.keys.sorted(), id: \.self) { rubro in
                                            HStack {
                                                Text(rubro)
                                                    .font(.body)
                                                    .foregroundColor(.gray)
                                                    .padding(.leading)
                                                Spacer()
                                                Text("\(String(format: "%.2f", calificacionesPrevias[rubro] ?? 0.0))")
                                                    .font(.body)
                                                    .foregroundColor(.black)
                                                    .padding(.trailing)
                                            }
                                            .padding(.vertical, 8)
                                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray5)))
                                        }
                                    }
                                    .padding(.top, 12)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 24)
                    } else {
                        // Formulario de calificación
                        VStack(spacing: 24) {
                            ForEach(rubros.keys.sorted(), id: \.self) { key in
                                VStack(spacing: 16) {
                                    HStack {
                                        Text(key)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\(calificaciones[selectedEquipo]?[nombreJuez]?[key] ?? 1.0, specifier: "%.1f")")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Slider(value: Binding(
                                        get: {
                                            calificaciones[selectedEquipo]?[nombreJuez]?[key] ?? 1.0
                                        },
                                        set: { newValue in
                                            if !alreadyRated {
                                                let score = min(max(newValue, 1), valorRubro)
                                                calificaciones[selectedEquipo, default: [:]][nombreJuez, default: [:]][key] = score
                                            }
                                        }
                                    ), in: 1...valorRubro, step: 1)
                                    .accentColor(.blue)
                                    .padding(.horizontal)
                                    .disabled(alreadyRated)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color(UIColor.systemGroupedBackground)))
                                .shadow(radius: 5)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    
                    // Botón de calificación
                    Button(action: {
                        showConfirmationAlert = true
                    }) {
                        Text("Calificar")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(radius: 5)
                    }
                    .padding(.top, 24)
                    .alert(isPresented: $showConfirmationAlert) {
                        Alert(
                            title: Text("Confirmación"),
                            message: Text("¿Estás seguro de que quieres calificar? Después de esto no podrás modificar tu calificación."),
                            primaryButton: .destructive(Text("Confirmar")) {
                                submitCalificaciones()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    // Sección de notas
                    VStack(spacing: 16) {
                        Toggle(isOn: $isNotesExpanded) {
                            Text("Notas del Juez")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .toggleStyle(SwitchToggleStyle(tint: .blue))

                        if isNotesExpanded {
                            TextEditor(text: $judgeNotes)
                                .frame(height: 150)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemGray5)))
                                .shadow(radius: 5)
                                .onChange(of: judgeNotes) { newValue in
                                    // Guardar las notas automáticamente al cambiar el texto
                                    saveNotes()
                                }

                            // El botón de guardar ya no es necesario, las notas se guardan automáticamente
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 24)
        }
        .onAppear {
            fetchValorRubro()
            fetchRubros()
            initializeCalificaciones()
            checkAlreadyRated()
            getNotas()
            getCalificacionesPrevias() // Cargar las calificaciones previas
        }
    }

    private func getCalificacionesPrevias() {
        viewModel.getCalificacionesJuez(for: selectedEquipo, judgeName: nombreJuez, hackClave: hackClaveInput) { result in
            switch result {
            case .success(let calificacionesData):
                self.calificacionesPrevias = calificacionesData
            case .failure(let error):
                print("Error al obtener calificaciones previas: \(error)")
            }
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

    private func getNotas() {
        viewModel.getNotas(for: hackClaveInput, judgeName: nombreJuez, teamName: selectedEquipo) { result in
            switch result {
            case .success(let notes):
                self.judgeNotes = notes
            case .failure(let error):
                print("Error al obtener notas: \(error)")
            }
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

    private func saveNotes() {
        viewModel.saveNotes(for: hackClaveInput, judgeName: nombreJuez, teamName: selectedEquipo, notes: judgeNotes) { result in
            switch result {
            case .success:
                print("Notas guardadas exitosamente.")
            case .failure(let error):
                print("Error al guardar notas: \(error)")
            }
        }
    }
}

#Preview {
    GradeView(hackClaveInput: "HACK24", selectedEquipo: "Equipo 1", nombreJuez: "NombreJuez", isActive: true)
}
