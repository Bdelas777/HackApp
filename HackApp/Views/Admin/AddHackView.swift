import SwiftUI

struct AddHackView: View {
    @State var nombre: String = ""
    @State var descripcion: String = ""
    @State var numJueces: Int = 1
    @State var date: Date = Date.now
    @State var tiempoPitch: Double = 0.0
    @StateObject var listaRubros = RubroViewModel()
    @State private var showingAlert = false
    @ObservedObject var listaHacks: HackViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var isFormValid: Bool {
        !nombre.isEmpty &&
        !descripcion.isEmpty &&
        tiempoPitch > 0 &&
        !listaRubros.rubroList.isEmpty
    }
    
    var body: some View {
        VStack {
            AddHackForm(
                nombre: $nombre,
                descripcion: $descripcion,
                numJueces: $numJueces,
                date: $date,
                tiempoPitch: $tiempoPitch,
                listaRubros: listaRubros,
                showingAlert: $showingAlert
            )
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
}

#Preview {
    AddHackView(listaHacks: HackViewModel())
}
