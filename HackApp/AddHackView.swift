import SwiftUI
import SwiftData

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
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext // For saving the Hack to the SwiftData model
    
    @ObservedObject var listaHacks: HackViewModel

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
                            .foregroundStyle(.green)
                    }
                    .popover(isPresented: $showingAddRubroPopover) {
                        AddRubroPopoverView(rubroNombre: $rubroNombre, rubroValor: $rubroValor) {
                            if let valor = Double(rubroValor) {
                                let nuevoRubro = Rubro(id: UUID(), nombre: rubroNombre, valor: valor)
                                listaRubros.rubroList.append(nuevoRubro)
                                rubroNombre = ""
                                rubroValor = ""
                                showingAddRubroPopover = false
                            } else {
                                // Error handling if needed
                            }
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
                // Create a new Hack object and save it to the SwiftData model context
                let nuevoHack = Hack(
                    nombre: nombre,
                    rubros: listaRubros.rubroList,
                    tiempoPitch: tiempoPitch,
                    equipoIDs: [], // Add equipo IDs if necessary
                    estaActivo: true,
                    juecesIDs: [], // Add jueces IDs if necessary
                    rangoPuntuacion: 1...5 // Example range
                )
                // Insert the Hack object into the model context
                modelContext.insert(nuevoHack)

                // Optionally, add it to the ViewModel list for immediate UI update
                listaHacks.hackList.append(nuevoHack)

                // Dismiss the view
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Guardar")
            }
            .buttonStyle(MainViewButtonStyle())
            .padding()
        }
    }
}

#Preview {
    AddHackView(listaHacks: HackViewModel())
}
