//
//  AddEquipoButton.swift
//  HackApp
//
//  Created by Alumno on 13/09/24.
//

import SwiftUI

struct AddEquipoButton: View {
    @Binding var showingAddEquipoPopover: Bool
    @ObservedObject var listaEquipos: EquipoViewModel
    @Binding var equipoNombre: String
    @Binding var showingAlert: Bool
    
    var body: some View {
        Button {
            showingAddEquipoPopover.toggle()
        } label: {
            Label("Añadir equipo", systemImage: "plus")
                .foregroundColor(.blue)
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
            let nuevoEquipo = Equipo(id: UUID(), nombre: equipoNombre)
            listaEquipos.equipoList.append(nuevoEquipo)
            equipoNombre = ""
            showingAddEquipoPopover = false
        } else {
            showingAlert = true
        }
    }
}
