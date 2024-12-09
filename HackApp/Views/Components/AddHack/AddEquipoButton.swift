//
//  AddEquipoButton.swift
//  HackApp
//
//  Created by Alumno on 13/09/24.
//
import SwiftUI

import SwiftUI

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
        }
        .popover(isPresented: $showingAddEquipoPopover) {
            AddEquipoPopoverView(
                equipoNombre: $equipoNombre,
                onSave: addEquipo,  // Pasar el closure de guardar
                onCancel: resetForm  // Pasar el closure de cancelar
            )
            .onDisappear {
                // Restablecer el valor del equipo si el popover desaparece
                if !showingAddEquipoPopover {
                    resetForm()
                }
            }
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
    
    private func resetForm() {
        equipoNombre = ""
        equipoAEditar = nil
        showingAddEquipoPopover = false
    }
}
