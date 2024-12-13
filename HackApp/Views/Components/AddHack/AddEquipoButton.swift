
import SwiftUI
/// Vista que muestra un botón para agregar un nuevo equipo o editar un equipo existente.
///
/// Este componente proporciona un botón para agregar un nuevo equipo al listado de equipos. Si un equipo está seleccionado para editar, este se actualiza con el nuevo nombre. También muestra un popover con un formulario para ingresar el nombre del equipo.
///
/// - Parameters:
///   - showingAddEquipoPopover: Un `Binding` que controla si el popover de agregar equipo está visible o no.
///   - listaEquipos: Un `ObservedObject` que contiene la lista de equipos, y permite agregar, editar o eliminar equipos.
///   - equipoNombre: Un `Binding` que contiene el nombre del equipo que se está agregando o editando.
///   - showingAlert: Un `Binding` para controlar la visibilidad de una alerta de error.
///   - equipoAEditar: Un `Binding` que puede contener un equipo seleccionado para editar.


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
        }
        .popover(isPresented: $showingAddEquipoPopover) {
            AddEquipoPopoverView(
                equipoNombre: $equipoNombre,
                onSave: addEquipo,
                onCancel: resetForm
            )
            .onDisappear {
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
                if let index = listaEquipos.equipoList.firstIndex(where: { $0.id == equipoAEditar.id }) {
                    listaEquipos.equipoList[index].nombre = equipoNombre
                }
            } else {
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
