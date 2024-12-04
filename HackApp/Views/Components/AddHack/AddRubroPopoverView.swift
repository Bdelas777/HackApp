//
//  AddRubroPopoverView.swift
//  HackApp
//
//  Created by Alumno on 12/09/24.
//

import SwiftUI
/// Vista que presenta un popover para agregar o editar un rubro.
/// Al presionar el botón "Guardar", se guarda el nombre y valor del rubro ingresado.
///
/// - `rubroNombre`: El nombre del rubro que se va a agregar o editar.
/// - `rubroValor`: El valor del rubro que se va a agregar o editar.
/// - `onSave`: Acción a ejecutar cuando el usuario guarda los cambios.
///
/// Esta vista permite a los usuarios ingresar el nombre y el valor de un rubro. Cuando el usuario presiona el botón "Guardar", se invoca la acción `onSave`
/// para guardar los cambios realizados. El valor de `rubroNombre` y `rubroValor` es el que se muestra y se guarda para el nuevo rubro o la edición de uno existente.
struct AddRubroPopoverView: View {
    @Binding var rubroNombre: String
    @Binding var rubroValor: String
    var onSave: () -> Void

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
            Button("Guardar") {
                onSave()
            }
            .padding()
        }
        .frame(width: 400, height: 320)
    }
}
