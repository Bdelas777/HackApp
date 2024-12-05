//
//  AddEquipoPopoverView.swift
//  HackApp
//
//  Created by Alumno on 13/09/24.
//

import SwiftUI

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
                    onCancel()  // Llamamos a la función de cancelar
                }
                .foregroundColor(.red)
                .padding()

                Button("Guardar") {
                    onSave()  // Llamamos a la función de guardar
                }
                .padding()
            }
        }
        .frame(width: 400, height: 200)
    }
}
