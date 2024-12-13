import SwiftUI

/// Vista emergente para agregar un juez, permitiendo ingresar el nombre del juez y guardar o cancelar la acción.
///
/// Esta vista contiene un campo de texto para ingresar el nombre del juez, y dos botones: uno para guardar el nombre y otro para cancelar la operación.
///
/// - Parameters:
///   - juezNombre: Un `Binding` que permite la edición del nombre del juez desde una vista externa.
///   - onSave: Acción a ejecutar cuando el usuario guarda el nombre del juez.
///   - onCancel: Acción a ejecutar cuando el usuario cancela la operación.
struct AddJuezPopoverView: View {
    @Binding var juezNombre: String
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Nombre del Juez")) {
                    TextField("Nombre", text: $juezNombre)
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

