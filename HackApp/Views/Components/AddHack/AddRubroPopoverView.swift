//
//  AddRubroPopoverView.swift
//  HackApp
//
//  Created by Alumno on 12/09/24.
//

import SwiftUI

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
                Section(header: Text("Valor del Rubro")) {
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
