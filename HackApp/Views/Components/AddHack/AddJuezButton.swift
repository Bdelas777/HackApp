//
//  AddJuezButton.swift
//  HackApp
//
//  Created by Alumno on 18/09/24.
//
import SwiftUI

/// Vista que presenta un botón para añadir un juez.
/// Al presionar el botón, se muestra un `Popover` para ingresar el nombre del juez y agregarlo a la lista.
///
/// - `showingAddJuezPopover`: Bandera vinculada para mostrar u ocultar el popover de añadir juez.
/// - `listaJueces`: El `JuezViewModel` que gestiona la lista de jueces.
/// - `juezNombre`: El nombre del juez a agregar o editar.
/// - `showingAlert`: Bandera que indica si se debe mostrar una alerta en caso de error al agregar el juez.
/// - `juezAEditar`: El juez que se está editando, si existe.
///
/// Esta vista gestiona tanto la adición de un nuevo juez como la edición de uno existente.
struct AddJuezButton: View {
    @Binding var showingAddJuezPopover: Bool
    @ObservedObject var listaJueces: JuezViewModel
    @Binding var juezNombre: String
    @Binding var showingAlert: Bool
    @Binding var juezAEditar: Juez?
    var body: some View {
        Button {
            if juezAEditar != nil {
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
                if let index = listaJueces.juezList.firstIndex(where: { $0.id == juezAEditar.id }) {
                    listaJueces.juezList[index].nombre = juezNombre
                }
            } else {
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
