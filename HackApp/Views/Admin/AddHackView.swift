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
                showingAlert: $showingAlert,
                listaHacks: listaHacks
            )
            
            .padding()
        }
        
    }
    
}
#Preview {
    AddHackView(listaHacks: HacksViewModel())  
}
