import SwiftUI

struct AddHackView: View {
    @State var nombre: String = ""
    @State var descripcion: String = ""
    @State var numJueces: Int = 1
    @State var date: Date = Date.now
    @State var tiempoPitch: Double = 0.0
    @StateObject var listaRubros = RubroViewModel()
    @State private var showingAddRubroPopover = false
    @State private var rubroNombre: String = ""
    @State private var rubroValor: String = ""
    @State private var showingAlert = false // State to trigger the alert
    @ObservedObject var listaHacks: HackViewModel
    @Environment(\.presentationMode) var presentationMode

    // Computed property to check if all fields are filled
    private var isFormValid: Bool {
        !nombre.isEmpty &&
        !descripcion.isEmpty &&
        tiempoPitch > 0 &&
        !listaRubros.rubroList.isEmpty
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Nombre del Hackathon")) {
                    TextField("Nombre del hack", text: $nombre)
                }
                Section(header: Text("Descripción del Hackathon")) {
                    TextField("Descripción del hack", text: $descripcion)
                }
                Section(header: Text("Número de jueces")) {
                    Picker("Número de jueces", selection: $numJueces) {
                        ForEach(1..<11) { index in
                            Text("\(index)")
                        }
                    }
                }
                Section(header: Text("Fecha de tu Hackathon")) {
                    DatePicker("Selecciona la fecha", selection: $date)
                }
                Section(header: Text("Duración del pitch (minutos)")) {
                    TextField("Tiempo de pitch (minutos)", value: $tiempoPitch, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Rubros")) {
                    Button {
                        showingAddRubroPopover.toggle()
                    } label: {
                        Label("Añadir rubro", systemImage: "plus")
                            .foregroundColor(totalRubroValue() >= 100 ? .gray : .green)
                    }
                    .disabled(totalRubroValue() >= 100)
                    .popover(isPresented: $showingAddRubroPopover) {
                        AddRubroPopoverView(
                            rubroNombre: $rubroNombre,
                            rubroValor: $rubroValor,
                            onSave: addRubro
                        )
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("Valor excedido"),
                                message: Text("El valor total de los rubros no puede exceder el 100%."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    ForEach(listaRubros.rubroList) { rubro in
                        HStack {
                            Text(rubro.nombre)
                            Spacer()
                            Text("\(rubro.valor, specifier: "%.0f")%")
                        }
                    }
                }
            }
            Button {
                let nuevoHack = Hack(
                    nombre: nombre,
                    rubros: listaRubros.rubroList,
                    tiempoPitch: tiempoPitch,
                    equipoIDs: [],
                    estaActivo: true,
                    juecesIDs: [],
                    rangoPuntuacion: 1...5
                )
                listaHacks.hackList.append(nuevoHack)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Guardar")
            }
            .buttonStyle(MainViewButtonStyle(isEnabled: isFormValid))
            .disabled(!isFormValid)
            .padding()
        }
    }

    private func addRubro() {
        if let valor = Double(rubroValor), totalRubroValue() + valor <= 100 {
            let nuevoRubro = Rubro(id: UUID(), nombre: rubroNombre, valor: valor)
            listaRubros.rubroList.append(nuevoRubro)
            rubroNombre = ""
            rubroValor = ""
            showingAddRubroPopover = false
        } else {
            showingAlert = true // Trigger the alert if value exceeds 100%
        }
    }

    private func totalRubroValue() -> Double {
        listaRubros.rubroList.reduce(0) { $0 + $1.valor }
    }
}

#Preview {
    AddHackView(listaHacks: HackViewModel())
}

