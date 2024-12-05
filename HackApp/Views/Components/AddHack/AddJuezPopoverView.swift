//
//  AddJuezPopoverView.swift
//  HackApp
//
//  Created by Alumno on 18/09/24.
//

import SwiftUI


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
