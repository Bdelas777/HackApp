//
//  AddJuezButton.swift
//  HackApp
//
//  Created by Alumno on 18/09/24.
//

import SwiftUI

struct AddJuezButton: View {
    @Binding var showingAddJuezPopover: Bool
    @ObservedObject var listaJueces: JuezViewModel
    @Binding var juezNombre: String
    @Binding var showingAlert: Bool

    var body: some View {
        Button {
            showingAddJuezPopover.toggle()
        } label: {
            Label("Añadir juez", systemImage: "plus")
                .foregroundColor(.blue)
                .autocorrectionDisabled(true)
        }
        .popover(isPresented: $showingAddJuezPopover) {
            AddJuezPopoverView(
                juezNombre: $juezNombre,
                onSave: addJuez
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("No se pudo agregar el juez."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func addJuez() {
        if !juezNombre.isEmpty {
            let nuevoJuez = Juez(id: UUID(), nombre: juezNombre)
            listaJueces.juezList.append(nuevoJuez)
            juezNombre = ""
            showingAddJuezPopover = false
        } else {
            showingAlert = true
        }
    }
}
