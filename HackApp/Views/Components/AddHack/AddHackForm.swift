
import SwiftUI

struct AddHackForm: View {
    @ObservedObject var formData: FormDataViewModel
    @ObservedObject var listaHacks: HacksViewModel
    @Binding var showingAlert: Bool
    @State private var currentStep: Int = 0
    @State private var steps: [String] = ["Información Básica", "Fechas", "Rúbrica", "Equipos", "Jueces", "Revisión"]
    private let totalSteps = 6
    @State private var alertMessage: String = ""
    @State private var showingAddRubroPopover = false
    @State private var showingAddEquipoPopover = false
    @State private var showingAddJuezPopover = false
    @State private var rubroNombre: String = ""
    @State private var rubroValor: String = ""
    @State private var equipoNombre: String = ""
    @State private var juezNombre: String = ""
    @State private var juezAEditar: Juez?
    @State private var equipoAEditar: Equipo?
    @ObservedObject var listaRubros = RubroViewModel()
    @ObservedObject var listaEquipos = EquipoViewModel()
    @ObservedObject  var listaJueces = JuezViewModel()

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            ProgressBar(progress: CGFloat(currentStep) / CGFloat(totalSteps))
                .padding()

            StepIndicator(currentStep: currentStep, totalSteps: totalSteps, steps: steps, onStepSelected: { step in
                currentStep = step
            })
            
            switch currentStep {
            case 0: basicInfoForm
            case 1: dateForm
            case 2: rubrosForm
            case 3: equiposForm
            case 4: juecesForm
            case 5: reviewForm
            default: EmptyView()
            }
            
            HStack {
                if currentStep > 0 {
                    Button("Anterior") {
                        currentStep -= 1
                    }
                    .padding()
                }
                
                Spacer()
                
                if currentStep < totalSteps - 1 {
                    Button("Siguiente") {
                        currentStep += 1
                    }
                    .padding()
                } else {
                    Button("Guardar") {
                        validateAndSave()
                    }
                    .padding()
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    var basicInfoForm: some View {
        Form {
            Section(header: Text("Nombre del Hackathon")) {
                TextField("Nombre del hack", text: $formData.nombre)
            }
            Section(header: Text("Clave del Hackathon")) {
                TextField("Clave del hack", text: $formData.clave)
                    .autocorrectionDisabled(true)
            }
            Section(header: Text("Descripción del Hackathon")) {
                TextField("Descripción del hack", text: $formData.descripcion)
            }
        }
    }

    var dateForm: some View {
        Form {
            Section(header: Text("Fecha de inicio del Hackathon")) {
                DatePicker("Selecciona la fecha inicio", selection: $formData.date)
            }
            Section(header: Text("Fecha de fin del Hackathon")) {
                DatePicker("Selecciona la fecha fin", selection: $formData.dateEnd)
            }
        }
    }

    var rubrosForm: some View {
        Form {
            Section(header: Text("Duración del pitch (minutos)")) {
                TextField("Valor máximo de los rubros", text: $formData.tiempoPitch)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Valor de la calificación máxima")) {
                TextField("Valor máximo de los rubros", text: $formData.valorRubro)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Rúbrica")) {
                AddRubroButton(
                    showingAddRubroPopover: $showingAddRubroPopover,
                    listaRubros: listaRubros,
                    rubroNombre: $rubroNombre,
                    rubroValor: $rubroValor,
                    showingAlert: $showingAlert
                )
                ForEach(listaRubros.rubroList, id: \.id) { rubro in
                    HStack {
                        Text(rubro.nombre)
                        Spacer()
                        Text("\(rubro.valor, specifier: "%.0f")%")
                        Button(action: {
                            rubroNombre = rubro.nombre
                            rubroValor = "\(rubro.valor)"
                            showingAddRubroPopover.toggle()
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
        }
    }

    var equiposForm: some View {
        Form {
            Section(header: Text("Equipos")) {
                AddEquipoButton(
                    showingAddEquipoPopover: $showingAddEquipoPopover,
                    listaEquipos: listaEquipos,
                    equipoNombre: $equipoNombre,
                    showingAlert: $showingAlert,
                    equipoAEditar: $equipoAEditar
                )
                
                // Mostrar la lista de equipos
                ForEach(listaEquipos.equipoList) { equipo in
                    HStack {
                        Text(equipo.nombre)
                        Button(action: {
                            equipoAEditar = equipo
                            equipoNombre = equipo.nombre
                            showingAddEquipoPopover.toggle()
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
        }
    }
    
    var juecesForm: some View {
        Form {
            Section(header: Text("Jueces")) {
                AddJuezButton(
                    showingAddJuezPopover: $showingAddJuezPopover,
                    listaJueces: listaJueces,
                    juezNombre: $juezNombre,
                    showingAlert: $showingAlert,
                    juezAEditar: $juezAEditar
                )
                
                ForEach(listaJueces.juezList) { juez in
                    HStack {
                        Text(juez.nombre)
                        
                        // Botón para editar el juez
                        Button(action: {
                            // Cuando se toca un juez, se carga su nombre para editar
                            juezAEditar = juez
                            juezNombre = juez.nombre
                            showingAddJuezPopover.toggle() // Mostrar popover de edición
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
        }
    }

    // Revisión final
    var reviewForm: some View {
        VStack {
            Text("Revisa la información antes de guardar")
                .font(.headline)
                .padding()

            Form {
                Section(header: Text("Información Básica")) {
                    Text("Nombre: \(formData.nombre)")
                    Text("Clave: \(formData.clave)")
                    Text("Descripción: \(formData.descripcion)")
                }

                Section(header: Text("Fechas")) {
                    Text("Fecha de inicio: \(formData.date, style: .date)")
                    Text("Fecha de fin: \(formData.dateEnd, style: .date)")
                }

                Section(header: Text("Rúbrica")) {
                    Text("Tiempo Pitch: \(formData.tiempoPitch) minutos")
                    Text("Calificación máxima: \(formData.valorRubro) ")
                    
                    ForEach(formData.listaRubros.rubroList) { rubro in
                        HStack {
                            Text("\(rubro.nombre): \(rubro.valor, specifier: "%.0f")%")
                            
                            Spacer()
                            
                            Button(action: {
                                eliminarRubro(rubro)
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                Section(header: Text("Equipos")) {
                    ForEach(formData.listaEquipos.equipoList) { equipo in
                                       HStack {
                                           Text(equipo.nombre)
                                           
                                           Spacer()
                                           Button(action: {
                                               eliminarEquipo(equipo)  // Llamamos a la función para eliminar el equipo
                                           }) {
                                               Image(systemName: "trash.circle.fill")
                                                   .foregroundColor(.red)
                                           }
                                       }
                                   }
                               }

                               Section(header: Text("Jueces")) {
                                   ForEach(formData.listaJueces.juezList) { juez in
                                       HStack {
                                           Text(juez.nombre)
                                           
                                           Spacer()
                                           
                                           // Botón de eliminación
                                           Button(action: {
                                               eliminarJuez(juez)  // Llamamos a la función para eliminar el juez
                                           }) {
                                               Image(systemName: "trash.circle.fill")
                                                   .foregroundColor(.red)
                                           }
                                       }
                                   }
                               }
                
            }
        }
    }

    func eliminarRubro(_ rubro: Rubro) {
        formData.listaRubros.eliminarRubro(rubro)
    }

    func eliminarEquipo(_ equipo: Equipo) {
        formData.listaEquipos.eliminarEquipo(equipo)
    }

    func eliminarJuez(_ juez: Juez) {
        formData.listaJueces.eliminarJuez(juez)
    }

    private func validateAndSave() {
        // Validaciones de los campos básicos
        if formData.nombre.isEmpty {
            alertMessage = "El nombre es obligatorio."
            showingAlert = true
            return
        }

        if formData.clave.isEmpty {
            alertMessage = "La clave es obligatoria."
            showingAlert = true
            return
        }

        if formData.date >= formData.dateEnd {
            alertMessage = "La fecha de inicio no puede ser posterior a la fecha de fin."
            showingAlert = true
            return
        }

        if formData.tiempoPitch.isEmpty {
            alertMessage = "El tiempo de pitch es obligatorio."
            showingAlert = true
            return
        }

        if let tiempo = Double(formData.tiempoPitch), tiempo < 0 {
            alertMessage = "El valor máximo del tiempo de pitch debe ser un número mayor a 0."
            showingAlert = true
            return
        }

        if !isNumeric(formData.tiempoPitch) {
            alertMessage = "El tiempo de pitch debe contener solo números."
            showingAlert = true
            return
        }

        if formData.valorRubro.isEmpty {
            alertMessage = "El valor máximo de los rubros es obligatorio."
            showingAlert = true
            return
        }

        if let valor = Double(formData.valorRubro), valor < 0 {
            alertMessage = "El valor máximo de los rubros debe ser un número mayor a 0."
            showingAlert = true
            return
        }

        if !isNumeric(formData.valorRubro) {
            alertMessage = "El valor de los rubros debe contener solo números."
            showingAlert = true
            return
        }

        // Validación de rubros
        if formData.listaRubros.rubroList.isEmpty {
            alertMessage = "Debe agregar al menos un rubro."
            showingAlert = true
            return
        }

        let totalRubroValue = formData.listaRubros.rubroList.reduce(0) { $0 + $1.valor }
        if totalRubroValue < 100 {
            alertMessage = "La suma de los valores de los rubros debe ser al menos 100."
            showingAlert = true
            return
        }

        // Validación de equipos
        if formData.listaEquipos.equipoList.isEmpty {
            alertMessage = "Debe agregar al menos un equipo."
            showingAlert = true
            return
        }

        // Validación de jueces
        if formData.listaJueces.juezList.isEmpty {
            alertMessage = "Debe agregar al menos un juez."
            showingAlert = true
            return
        }

        // Verificar si la clave ya existe
        listaHacks.checkIfKeyExists(formData.clave) { exists in
            if exists {
                DispatchQueue.main.async {
                    alertMessage = "No se puede guardar porque ya existe un hack con esa clave."
                    showingAlert = true
                }
                return
            }

            // Crear el nuevo HackModel
            let nuevoHack = HackModel(
                clave: formData.clave,
                descripcion: formData.descripcion,
                equipos: formData.listaEquipos.equipoList.map { $0.nombre },
                jueces: formData.listaJueces.juezList.map { $0.nombre },
                rubros: formData.listaRubros.rubroList.reduce(into: [String: Double]()) { $0[$1.nombre] = $1.valor },
                estaActivo: true,
                nombre: formData.nombre,
                tiempoPitch: Double(formData.tiempoPitch) ?? 0.0,
                FechaStart: formData.date,
                FechaEnd: formData.dateEnd,
                valorRubro: Int(formData.valorRubro) ?? 0,
                notas: formData.listaEquipos.equipoList.reduce(into: [String: [String: String]]()) { equipoNotas, equipo in
                    var notasPorEquipo = [String: String]()
                    for juez in formData.listaJueces.juezList {
                        notasPorEquipo[juez.nombre] = ""
                    }
                    equipoNotas[equipo.nombre] = notasPorEquipo
                },
                estaIniciado: false
            )
            listaHacks.addHack(hack: nuevoHack) { result in
                switch result {
                case .success:
                    formData.resetForm()
                    presentationMode.wrappedValue.dismiss()
                    listaHacks.fetchHacks()
                case .failure(let error):
                    alertMessage = "Error al guardar el hack: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }

}

private func isNumeric(_ str: String) -> Bool {
    let numericCharacterSet = CharacterSet(charactersIn: "0123456789.")
    let invertedCharacterSet = numericCharacterSet.inverted
    return str.rangeOfCharacter(from: invertedCharacterSet) == nil
}
