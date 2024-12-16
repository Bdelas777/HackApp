
import SwiftUI
/// `AddHackView` es una vista de SwiftUI que permite a los usuarios agregar un nuevo hackathon mediante un formulario.
/// Utiliza múltiples modelos de vista para gestionar los datos del formulario, como equipos, jueces, rubros y hacks existentes.
/// Esta vista también maneja la lógica para mostrar alertas cuando ocurren eventos importantes o errores.
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
        listaRubros: RubroViewModel(),
        listaEquipos: EquipoViewModel(),
        listaJueces: JuezViewModel()
    )
}
