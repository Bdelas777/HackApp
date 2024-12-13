import SwiftUI
/// Vista que muestra un botón para agregar un nuevo rubro (criterio de evaluación) o editar uno existente.
///
/// Este componente proporciona un botón para agregar un nuevo rubro al listado de rubros. Si un rubro está seleccionado para editar, este se actualiza con el nuevo nombre y valor. También muestra un popover con un formulario para ingresar el nombre y valor del rubro. El valor total de los rubros no puede exceder el 100%, y se muestra una alerta si se intenta guardar un valor que exceda este límite.
///
/// - Parameters:
///   - showingAddRubroPopover: Un `Binding` que controla si el popover de agregar rubro está visible o no.
///   - listaRubros: Un `ObservedObject` que contiene la lista de rubros, y permite agregar, editar o eliminar rubros.
///   - rubroNombre: Un `Binding` que contiene el nombre del rubro que se está agregando o editando.
///   - rubroValor: Un `Binding` que contiene el valor del rubro que se está agregando o editando.
///   - showingAlert: Un `Binding` para controlar la visibilidad de una alerta de error si el valor total de los rubros excede el 100%.
///   - rubroAEditar: Un `Binding` que puede contener un rubro seleccionado para editar.

struct AddRubroButton: View {
    @Binding var showingAddRubroPopover: Bool
    @ObservedObject var listaRubros: RubroViewModel
    @Binding var rubroNombre: String
    @Binding var rubroValor: String
    @Binding var showingAlert: Bool
    @Binding var rubroAEditar: Rubro?

    var body: some View {
        Button {
            showingAddRubroPopover.toggle()
        } label: {
            Label("Añadir criterio", systemImage: "plus")
                .foregroundColor(.blue)
        }
        .popover(isPresented: $showingAddRubroPopover) {
            AddRubroPopoverView(
                rubroNombre: $rubroNombre,
                rubroValor: $rubroValor,
                onSave: saveRubro,
                onCancel: resetForm
            )
            .onDisappear {
                // Restablecer los valores si el popover desaparece (por clic fuera)
                if !showingAddRubroPopover {
                    resetForm()
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Valor excedido"),
                    message: Text("El valor total de los rubros no puede exceder el 100%."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func saveRubro() {
        if let valor = Double(rubroValor) {
            let totalAntesDeGuardar = totalRubroValue(excludingEditedRubro: rubroAEditar)

            if totalAntesDeGuardar + valor <= 100 {
                if let rubroAEditar = rubroAEditar {
                    if let index = listaRubros.rubroList.firstIndex(where: { $0.id == rubroAEditar.id }) {
                        listaRubros.rubroList[index].nombre = rubroNombre
                        listaRubros.rubroList[index].valor = valor
                    }
                } else {
                    let nuevoRubro = Rubro(nombre: rubroNombre, valor: valor)
                    listaRubros.rubroList.append(nuevoRubro)
                }
                resetForm()
            } else {
                showingAlert = true
            }
        }
    }


    private func resetForm() {
        rubroNombre = ""
        rubroValor = ""
        rubroAEditar = nil
        showingAddRubroPopover = false
    }

    private func totalRubroValue(excludingEditedRubro rubroAEditar: Rubro?) -> Double {
        if let rubroAEditar = rubroAEditar {
            return listaRubros.rubroList.filter { $0.id != rubroAEditar.id }.reduce(0) { $0 + $1.valor }
        } else {
            return listaRubros.rubroList.reduce(0) { $0 + $1.valor }
        }
    }

}
