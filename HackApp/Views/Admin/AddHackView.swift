import SwiftUI

struct AddHackView: View {
    @State var clave: String = ""
    @State var nombre: String = ""
    @State var descripcion: String = ""
    @State var date: Date = Date()
    @State var dateEnd: Date = Date()
    @State var valorRubro: String = ""
    @State var tiempoPitch: String = ""
    @StateObject var listaRubros = RubroViewModel()
    @StateObject var listaEquipos = EquipoViewModel()
    @StateObject var listaJueces = JuezViewModel()
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @ObservedObject var listaHacks: HacksViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            AddHackForm(
                nombre: $nombre, clave: $clave,
                descripcion: $descripcion,
                date: $date,
                dateEnd: $dateEnd,
                valorRubro: $valorRubro,
                tiempoPitch: $tiempoPitch,
                listaRubros: listaRubros,
                listaEquipos: listaEquipos,
                listaJueces: listaJueces,
                showingAlert: $showingAlert
            )
            Button {
                validateAndSave()
            } label: {
                Text("Guardar")
            }
            .padding()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateAndSave() {
        // Validar campos obligatorios
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
              
              let nuevoHack = HackPrueba(
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

#Preview {
    AddHackView(listaHacks: HacksViewModel())
}
