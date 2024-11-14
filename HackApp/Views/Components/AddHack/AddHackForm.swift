//
//  AddHackForm.swift
//  HackApp
//
//  Created by Alumno on 12/09/24.
//
import SwiftUI

struct AddHackForm: View {
    @Binding var nombre: String
    @Binding var clave: String
    @Binding var descripcion: String
    @Binding var date: Date
    @Binding var dateEnd: Date
    @Binding var valorRubro: String
    @Binding var tiempoPitch: String
    @ObservedObject var listaRubros: RubroViewModel
    @ObservedObject var listaEquipos: EquipoViewModel
    @ObservedObject var listaJueces: JuezViewModel
    @Binding var showingAlert: Bool
    @State private var showingAddRubroPopover = false
    @State private var showingAddEquipoPopover = false
    @State private var showingAddJuezPopover = false
    @State private var rubroNombre: String = ""
    @State private var rubroValor: String = ""
    @State private var equipoNombre: String = ""
    @State private var juezNombre: String = ""
    @State private var currentStep: Int = 0  // Paso actual
    @State private var steps: [String] = ["Información Básica", "Fechas", "Rúbrica", "Equipos", "Jueces", "Revisión"]
    private let totalSteps = 6
    @State private var alertMessage: String = ""
    @ObservedObject var listaHacks: HacksViewModel
    @State private var juezAEditar: Juez?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var equipoAEditar: Equipo?

    var body: some View {
        VStack {
            ProgressBar(progress: CGFloat(currentStep) / CGFloat(totalSteps))
                .padding()

            StepIndicator(currentStep: currentStep, totalSteps: totalSteps, steps: steps, onStepSelected: { step in
                currentStep = step
            })
            
            // Formulario por paso
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

    // Información básica
    var basicInfoForm: some View {
        Form {
            Section(header: Text("Nombre del Hackathon")) {
                TextField("Nombre del hack", text: $nombre)
            }
            Section(header: Text("Clave del Hackathon")) {
                TextField("Clave del hack", text: $clave)
                    .autocorrectionDisabled(true)
            }
            Section(header: Text("Descripción del Hackathon")) {
                TextField("Descripción del hack", text: $descripcion)
            }
        }
    }

    // Fechas
    var dateForm: some View {
        Form {
            Section(header: Text("Fecha de inicio del Hackathon")) {
                DatePicker("Selecciona la fecha inicio", selection: $date)
            }
            Section(header: Text("Fecha de fin del Hackathon")) {
                DatePicker("Selecciona la fecha fin", selection: $dateEnd)
            }
        }
    }

    var rubrosForm: some View {
        Form {
            Section(header: Text("Duración del pitch (minutos)")) {
                TextField("Valor máximo de los rubros", text: $tiempoPitch)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Valor de la calificación máxima")) {
                TextField("Valor máximo de los rubros", text: $valorRubro)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Rúbrica")) {
                // Componente para añadir o editar rubros
                AddRubroButton(
                    showingAddRubroPopover: $showingAddRubroPopover,
                    listaRubros: listaRubros,
                    rubroNombre: $rubroNombre,
                    rubroValor: $rubroValor,
                    showingAlert: $showingAlert
                )
                
                // Lista de rubros (ForEach) con botón de eliminar
                ForEach(listaRubros.rubroList, id: \.id) { rubro in
                    HStack {
                        Text(rubro.nombre)
                        Spacer()
                        Text("\(rubro.valor, specifier: "%.0f")%")
                        
                        // Botón de editar
                        Button(action: {
                            // Cargar datos del rubro para editar
                            rubroNombre = rubro.nombre
                            rubroValor = "\(rubro.valor)"
                            showingAddRubroPopover.toggle() // Muestra el popover de edición
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.yellow)
                        }
                        
                        
                    }
                }
            }
        }
    }


    // Equipos
    var equiposForm: some View {
        Form {
            Section(header: Text("Equipos")) {
                AddEquipoButton(showingAddEquipoPopover: $showingAddEquipoPopover,
                                listaEquipos: listaEquipos,
                                equipoNombre: $equipoNombre,
                                showingAlert: $showingAlert,
                                equipoAEditar: $equipoAEditar)
                
                ForEach(listaEquipos.equipoList) { equipo in
                    HStack {
                        Text(equipo.nombre)
                        
                        // Botón para editar equipo
                        Button(action: {
                            // Cuando se toca un equipo, se carga su nombre para editar
                            equipoAEditar = equipo
                            equipoNombre = equipo.nombre
                            showingAddEquipoPopover.toggle() // Mostrar popover de edición
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
        }
    }


    // Jueces
    var juecesForm: some View {
        Form {
                    Section(header: Text("Jueces")) {
                        AddJuezButton(
                            showingAddJuezPopover: $showingAddJuezPopover,
                            listaJueces: listaJueces,
                            juezNombre: $juezNombre,
                            showingAlert: $showingAlert,
                            juezAEditar: $juezAEditar // Pasamos el binding aquí
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

            // Mostrar el resumen de los datos ingresados
            Form {
                Section(header: Text("Información Básica")) {
                    Text("Nombre: \(nombre)")
                    Text("Clave: \(clave)")
                    Text("Descripción: \(descripcion)")
                }

                Section(header: Text("Fechas")) {
                    Text("Fecha de inicio: \(date, style: .date)")
                    Text("Fecha de fin: \(dateEnd, style: .date)")
                }

                Section(header: Text("Rúbrica")) {
                    Text("Tiempo Pitch: \(tiempoPitch) minutos")
                    Text("Calificación máxima: \(valorRubro) ")
                    
                    ForEach(listaRubros.rubroList) { rubro in
                        HStack {
                            Text("\(rubro.nombre): \(rubro.valor, specifier: "%.0f")%")
                            
                            Spacer()
                            
                            // Botón de eliminación
                            Button(action: {
                                eliminarRubro(rubro)  // Llamamos a la función para eliminar el rubro
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }



                Section(header: Text("Equipos")) {
                    ForEach(listaEquipos.equipoList) { equipo in
                        HStack {
                            Text(equipo.nombre)
                            
                            Spacer()
                            
                            // Botón de eliminación
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
                    ForEach(listaJueces.juezList) { juez in
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
        listaRubros.eliminarRubro(rubro)  // Llamas al método del ViewModel para eliminar el rubro
    }

    func eliminarEquipo(_ equipo: Equipo) {
        listaEquipos.eliminarEquipo(equipo)  // Llamas al método del ViewModel para eliminar el equipo
    }

    func eliminarJuez(_ juez: Juez) {
        listaJueces.eliminarJuez(juez)  // Llamas al método del ViewModel para eliminar el juez
    }

    private func validateAndSave() {
        if nombre.isEmpty {
            alertMessage = "El nombre es obligatorio."
            showingAlert = true
            return
        }
        
        if clave.isEmpty {
            alertMessage = "La clave es obligatoria."
            showingAlert = true
            return
        }
        
        if date >= dateEnd {
            alertMessage = "La fecha de inicio no puede ser posterior a la fecha de fin."
            showingAlert = true
            return
        }
        
        if tiempoPitch.isEmpty{
            alertMessage = "El tiempo de pitch es obligatorio."
            showingAlert = true
            return
        }
        
        if let tiempo = Double(tiempoPitch), tiempo < 0 {
            alertMessage = "El valor máximo del tiempo de pitch debe ser un número mayor a 0."
            showingAlert = true
            return
        }
        
        if !isNumeric(tiempoPitch) {
            alertMessage = "El tiempo de pitch debe contener solo números."
            showingAlert = true
            return
        }
        
        if valorRubro.isEmpty {
            alertMessage = "El valor máximo de los rubros es obligatorio."
            showingAlert = true
            return
        }
        
        if let valor = Double(valorRubro), valor < 0 {
            alertMessage = "El valor máximo de los rubros debe ser un número mayor a 0."
            showingAlert = true
            return
        }
        if !isNumeric(valorRubro) {
            alertMessage = "El valor de los rubros debe contener solo números."
            showingAlert = true
            return
        }
        
        
        if listaRubros.rubroList.isEmpty {
            alertMessage = "Debe agregar al menos un rubro."
            showingAlert = true
            return
        }
        
        let totalRubroValue = listaRubros.rubroList.reduce(0) { $0 + $1.valor }
        if totalRubroValue < 100 {
            alertMessage = "La suma de los valores de los rubros debe ser al menos 100."
            showingAlert = true
            return
        }
        
        if listaEquipos.equipoList.isEmpty {
            alertMessage = "Debe agregar al menos un equipo."
            showingAlert = true
            return
        }

        if listaJueces.juezList.isEmpty {
            alertMessage = "Debe agregar al menos un juez."
            showingAlert = true
            return
        }
        
        listaHacks.checkIfKeyExists(clave) { exists in
              if exists {
                  DispatchQueue.main.async {
                      alertMessage = "No se puede guardar porque ya existe un hack con esa clave."
                      showingAlert = true
                  }
                  return
              }
              
              let nuevoHack = HackModel(
                  clave: clave,
                  descripcion: descripcion,
                  equipos: listaEquipos.equipoList.map { $0.nombre },
                  jueces: listaJueces.juezList.map { $0.nombre },
                  rubros: listaRubros.rubroList.reduce(into: [String: Double]()) { $0[$1.nombre] = $1.valor },
                  estaActivo: true,
                  nombre: nombre,
                  tiempoPitch: Double(tiempoPitch) ?? 0.0,
                  FechaStart: date,
                  FechaEnd: dateEnd,
                  valorRubro: Int(valorRubro) ?? 0
              )
              
            listaHacks.addHack(hack: nuevoHack) { result in
                switch result {
                case .success:
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




struct StepIndicator: View {
    var currentStep: Int
    var totalSteps: Int
    var steps: [String]
    var onStepSelected: (Int) -> Void
    
    var body: some View {
        HStack {
            ForEach(0..<totalSteps, id: \.self) { step in
                VStack {
                    Button(action: {
                        onStepSelected(step)  // Cambiar el paso cuando se haga clic en la sección
                    }) {
                        Text(steps[step])
                            .font(.footnote)
                            .foregroundColor(currentStep == step ? .blue : .gray)
                            .padding(5)
                    }
                    .buttonStyle(PlainButtonStyle()) // Evita que el botón se vea con un estilo predeterminado
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(currentStep >= step ? .blue : .gray)
                }
                if step < totalSteps - 1 {
                    Spacer()
                }
            }
        }
        .padding()
    }
}


struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        ProgressView(value: progress, total: 1)
            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            .frame(height: 10)
            .padding([.leading, .trailing])
    }
}

