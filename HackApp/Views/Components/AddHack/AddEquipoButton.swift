
import SwiftUI

struct AddEquipoButton: View {
    @Binding var showingAddEquipoPopover: Bool
    @ObservedObject var listaEquipos: EquipoViewModel
    @Binding var equipoNombre: String
    @Binding var showingAlert: Bool
    @Binding var equipoAEditar: Equipo? 
    
    var body: some View {
        Button {
            equipoAEditar = nil 
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
