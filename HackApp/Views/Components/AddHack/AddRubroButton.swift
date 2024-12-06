import SwiftUI

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
            // Si estamos editando un rubro, restamos su valor anterior del total
            let totalAntesDeGuardar = totalRubroValue(excludingEditedRubro: rubroAEditar)

            // Verificamos si el nuevo valor no excede el 100%
            if totalAntesDeGuardar + valor <= 100 {
                if let rubroAEditar = rubroAEditar {
                    // Si estamos editando un rubro, actualizamos el valor
                    if let index = listaRubros.rubroList.firstIndex(where: { $0.id == rubroAEditar.id }) {
                        listaRubros.rubroList[index].nombre = rubroNombre
                        listaRubros.rubroList[index].valor = valor
                    }
                } else {
                    // Si no estamos editando un rubro, agregamos uno nuevo
                    let nuevoRubro = Rubro(nombre: rubroNombre, valor: valor)
                    listaRubros.rubroList.append(nuevoRubro)
                }

                // Resetear el formulario después de guardar
                resetForm()
            } else {
                showingAlert = true
            }
        }
    }


    private func resetForm() {
        // Restablecer los valores a los predeterminados
        rubroNombre = ""
        rubroValor = ""
        rubroAEditar = nil
        showingAddRubroPopover = false
    }

    private func totalRubroValue(excludingEditedRubro rubroAEditar: Rubro?) -> Double {
        // Si hay un rubro que estamos editando, lo excluimos del total
        if let rubroAEditar = rubroAEditar {
            return listaRubros.rubroList.filter { $0.id != rubroAEditar.id }.reduce(0) { $0 + $1.valor }
        } else {
            // Si no estamos editando, sumamos todos los valores
            return listaRubros.rubroList.reduce(0) { $0 + $1.valor }
        }
    }

}
