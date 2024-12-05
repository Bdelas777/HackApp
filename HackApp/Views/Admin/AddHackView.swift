
import SwiftUI

struct AddHackView: View {
    @ObservedObject var formData: FormDataViewModel
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @ObservedObject var listaHacks: HacksViewModel
    @ObservedObject  var listaRubros : RubroViewModel
    @ObservedObject  var listaEquipos : EquipoViewModel
    @ObservedObject var listaJueces : JuezViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            AddHackForm(
                formData: formData,
                listaHacks: listaHacks,
                showingAlert: $showingAlert,
                listaRubros: listaRubros,
                listaEquipos: listaEquipos, listaJueces: listaJueces
                
            )
            .padding()
        }
    }
}

#Preview {
    AddHackView(
        formData: FormDataViewModel(listaRubros: RubroViewModel(), listaEquipos: EquipoViewModel(), listaJueces: JuezViewModel()),
        listaHacks: HacksViewModel(),
        listaRubros: RubroViewModel(),  // Pasa la instancia de RubroViewModel
        listaEquipos: EquipoViewModel(),  // Pasa la instancia de EquipoViewModel
        listaJueces: JuezViewModel()  // Pasa la instancia de JuezViewModel
    )
}
