//
//  AddJuezPopoverView.swift
//  HackApp
//
//  Created by Alumno on 18/09/24.
//

import SwiftUI

/// Vista de popover que permite ingresar y guardar el nombre de un juez.
/// Esta vista se utiliza para crear o editar un juez en la lista.
///
/// - `juezNombre`: Un enlace `@Binding` al nombre del juez que se está ingresando o editando.
/// - `onSave`: Una función que se ejecuta cuando el usuario guarda el nombre del juez.
///
/// Esta vista contiene un campo de texto donde se puede ingresar el nombre del juez
/// y un botón para guardar el valor ingresado.
struct AddJuezPopoverView: View {
    @Binding var juezNombre: String
    var onSave: () -> Void

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Nombre del Juez")) {
                    TextField("Nombre", text: $juezNombre)
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
