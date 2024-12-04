
import SwiftUI

struct AddHackView: View {
    @ObservedObject var formData: FormDataViewModel
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @ObservedObject var listaHacks: HacksViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            AddHackForm(
                formData: formData,
                listaHacks: listaHacks,
                showingAlert: $showingAlert
            )
            .padding()
        }
    }
}

#Preview {
    AddHackView(formData: FormDataViewModel(listaRubros: RubroViewModel(), listaEquipos: EquipoViewModel(), listaJueces: JuezViewModel()), listaHacks: HacksViewModel())
}
