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
    @Binding var juezAEditar: Juez? // Recibimos el binding del juez a editar
    
    var body: some View {
        Button {
            if juezAEditar != nil {
                // Si estamos editando un juez, lo resetemos a nil para un nuevo juez
                juezAEditar = nil
            }
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
            if let juezAEditar = juezAEditar {
                // Si estamos editando, actualizamos el nombre del juez
                if let index = listaJueces.juezList.firstIndex(where: { $0.id == juezAEditar.id }) {
                    listaJueces.juezList[index].nombre = juezNombre
                }
            } else {
                // Si no estamos editando, agregamos un nuevo juez
                let nuevoJuez = Juez(id: UUID(), nombre: juezNombre)
                listaJueces.juezList.append(nuevoJuez)
            }
            juezNombre = ""
            showingAddJuezPopover = false
        } else {
            showingAlert = true
        }
    }
}
