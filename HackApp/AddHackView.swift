import SwiftUI

struct AddHackView: View {
    @State var nombre: String = ""
    @State var descripcion: String = ""
    @State var numJueces: Int = 0
    @State var date: Date = Date.now
    @State var tiempoPitch: Double = 0.0
    @StateObject var listaRubros = RubroViewModel()
    @State private var showingAddRubroPopover = false
    @State private var rubroNombre: String = ""
    @State private var rubroValor: String = ""
    @ObservedObject var listaHacks: HackViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
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
                                // Manejo de error en la conversión
                                // Puedes mostrar una alerta aquí si lo deseas
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
            Button{
                let nuevoHack = Hack(
                    id: UUID(),
                    nombre: nombre,
                    rubros: listaRubros.rubroList,
                    tiempoPitch: tiempoPitch,
                    equipoIDs: [], // Agregar equipos si es necesario
                    estaActivo: true,
                    juecesIDs: [], // Agregar jueces si es necesario
                    rangoPuntuacion: 1...5 // Agregar textfield
                )
                listaHacks.hackList.append(nuevoHack)
                presentationMode.wrappedValue.dismiss()
            }label: {
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

