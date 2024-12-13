
import SwiftUI

/// Vista que permite agregar un nuevo equipo en el contexto de un hackathon.
///
/// Esta vista es un popover que se utiliza para agregar un nuevo equipo al hackathon. El usuario puede ingresar el nombre del equipo. Incluye botones para guardar el nuevo equipo o cancelar la operación.
///
/// - Parameters:
///   - equipoNombre: Un `Binding` que contiene el nombre del equipo que se está agregando.
///   - onSave: Una función de cierre que se llama cuando el usuario guarda el equipo.
///   - onCancel: Una función de cierre que se llama cuando el usuario cancela la operación y se cierra el popover.
///   
struct AddEquipoPopoverView: View {
    @Binding var equipoNombre: String
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Nombre del Equipo")) {
                    TextField("Nombre", text: $equipoNombre)
                        .autocorrectionDisabled(true)
                }
            }
            .padding()
            HStack {
                Button("Cancelar") {
                    onCancel()
                }
                .foregroundColor(.red)
                .padding()

                Button("Guardar") {
                    onSave() 
                }
                .padding()
            }
        }
        .frame(width: 400, height: 200)
    }
}
