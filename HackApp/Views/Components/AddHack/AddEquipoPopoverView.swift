//
//  AddEquipoPopoverView.swift
//  HackApp
//
//  Created by Alumno on 13/09/24.
//

import SwiftUI

/// Vista que presenta un popover para agregar un nuevo equipo.
/// Al presionar el botón "Guardar", se guarda el nombre del equipo ingresado.
///
/// - `equipoNombre`: El nombre del equipo a agregar.
/// - `onSave`: Acción a ejecutar cuando el usuario guarda el nombre del equipo.
///
/// Esta vista permite a los usuarios ingresar el nombre de un equipo. Cuando el usuario presiona el botón "Guardar", se invoca la acción `onSave`
/// para guardar el nombre del equipo ingresado.

struct AddEquipoPopoverView: View {
    @Binding var equipoNombre: String
    var onSave: () -> Void

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Nombre del Equipo")) {
                    TextField("Nombre", text: $equipoNombre)
                        .autocorrectionDisabled(true)
                }
            }
            .padding()
            Button("Guardar") {
                onSave()
            }
            .padding()
        }
        .frame(width: 400, height: 200)
    }
}
