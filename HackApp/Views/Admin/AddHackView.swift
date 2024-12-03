import SwiftUI
/// Vista para agregar un nuevo Hackathon.
///
/// Esta vista permite al usuario ingresar los detalles de un nuevo hackathon, incluyendo su clave, nombre, descripción,
/// fechas, rubros, tiempo de pitch, equipos y jueces. La vista también incluye una alerta para confirmar la creación del hackathon.
///
/// **Propiedades**:
/// - `clave`, `nombre`, `descripcion`: Campos de texto para los datos del hackathon.
/// - `date`, `dateEnd`: Fechas de inicio y fin del hackathon.
/// - `valorRubro`, `tiempoPitch`: Campos para el valor del rubro y el tiempo de pitch.
/// - `listaRubros`, `listaEquipos`, `listaJueces`: Modelos para manejar los rubros, equipos y jueces.
/// - `showingAlert`, `alertMessage`: Estados para mostrar una alerta de confirmación.
/// - `listaHacks`: Vista del modelo de hacks para agregar un nuevo hackathon.
/// - `presentationMode`: Control de la presentación para cerrar la vista después de agregar el hackathon.
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
