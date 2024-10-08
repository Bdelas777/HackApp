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

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Nombre del Equipo")) {
                    TextField("Nombre", text: $equipoNombre)
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


