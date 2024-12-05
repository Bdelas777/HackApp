// AddRubroPopoverView.swift
import SwiftUI

struct AddRubroPopoverView: View {
    @Binding var rubroNombre: String
    @Binding var rubroValor: String
    var onSave: () -> Void
    var onCancel: () -> Void  // Nueva función de cancelación

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
                    onSave()  // Guardamos el rubro
                }) {
                    Text("Guardar")
                }
                .padding()
            }
        }
        .frame(width: 400, height: 320)
    }
}
