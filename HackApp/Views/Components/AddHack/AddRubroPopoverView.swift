
import SwiftUI
/// Vista que permite agregar o editar un "Rubro" (criterio de calificación) en el hackathon.
///
/// Este popover se utiliza para agregar un nuevo rubro o editar uno existente. El usuario puede ingresar el nombre del rubro y el valor correspondiente (en porcentaje). Incluye botones para guardar los cambios o cancelar la operación.
///
/// - Parameters:
///   - rubroNombre: Un `Binding` que contiene el nombre del rubro que se está agregando o editando.
///   - rubroValor: Un `Binding` que contiene el valor (porcentaje) del rubro.
///   - onSave: Una función de cierre que se llama cuando el usuario guarda el rubro.
///   - onCancel: Una función de cierre que se llama cuando el usuario cancela la operación y se cierra el popover.
///   
struct AddRubroPopoverView: View {
    @Binding var rubroNombre: String
    @Binding var rubroValor: String
    var onSave: () -> Void
    var onCancel: () -> Void  

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Nombre del Criterio")) {
                    TextField("Nombre", text: $rubroNombre)
                        .autocorrectionDisabled(true)
                }
                Section(header: Text("Valor del Rubro(%)")) {
                    TextField("Valor", text: $rubroValor)
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled(true)
                }
            }
            .padding()

            HStack {
                Button(action: {
                    onCancel()  // Llamamos a la función de cancelación para resetear los valores
                }) {
                    Text("Cancelar")
                        .foregroundColor(.red)
                }
                .padding()

                Button(action: {
                    onSave()
                }) {
                    Text("Guardar")
                }
                .padding()
            }
        }
        .frame(width: 400, height: 320)
    }
}
