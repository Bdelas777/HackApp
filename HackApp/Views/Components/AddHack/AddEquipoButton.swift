//
//  AddEquipoButton.swift
//  HackApp
//
//  Created by Alumno on 13/09/24.
//
import SwiftUI
/// Vista que presenta un botón para añadir un equipo.
/// Al presionar el botón, se muestra un `Popover` para ingresar el nombre del equipo y agregarlo a la lista.
///
/// - `showingAddEquipoPopover`: Bandera vinculada para mostrar u ocultar el popover de añadir equipo.
/// - `listaEquipos`: El `EquipoViewModel` que gestiona la lista de equipos.
/// - `equipoNombre`: El nombre del equipo a agregar o editar.
/// - `showingAlert`: Bandera que indica si se debe mostrar una alerta en caso de error al agregar el equipo.
/// - `equipoAEditar`: El equipo que se está editando, si existe.
///
/// Esta vista gestiona tanto la adición de un nuevo equipo como la edición de uno existente.

struct AddEquipoButton: View {
    @Binding var showingAddEquipoPopover: Bool
    @ObservedObject var listaEquipos: EquipoViewModel
    @Binding var equipoNombre: String
    @Binding var showingAlert: Bool
    @Binding var equipoAEditar: Equipo? // Este binding lo recibimos desde EquiposForm
    
    var body: some View {
        Button {
            equipoAEditar = nil // Resetear el equipo a editar al pulsar "Añadir equipo"
            showingAddEquipoPopover.toggle()
        } label: {
            Label("Añadir equipo", systemImage: "plus")
                .foregroundColor(.blue)
                .autocorrectionDisabled(true)
        }
        .popover(isPresented: $showingAddEquipoPopover) {
            AddEquipoPopoverView(
                equipoNombre: $equipoNombre,
                onSave: addEquipo
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("No se pudo agregar el equipo."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func addEquipo() {
        if !equipoNombre.isEmpty {
            if let equipoAEditar = equipoAEditar {
                // Si existe un equipo a editar, lo actualizamos
                if let index = listaEquipos.equipoList.firstIndex(where: { $0.id == equipoAEditar.id }) {
                    listaEquipos.equipoList[index].nombre = equipoNombre
                }
            } else {
                // Si no existe un equipo a editar, agregamos uno nuevo
                let nuevoEquipo = Equipo(id: UUID(), nombre: equipoNombre)
                listaEquipos.equipoList.append(nuevoEquipo)
            }
            equipoNombre = ""
            showingAddEquipoPopover = false
        } else {
            showingAlert = true
        }
    }
}
