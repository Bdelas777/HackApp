//
//  AddRubroButton.swift
//  HackApp
//
//  Created by Alumno on 12/09/24.
//

import SwiftUI
/// Vista que presenta un botón para añadir un rubro (criterio de calificación).
/// Al presionar el botón, se muestra un `Popover` para ingresar el nombre y el valor del rubro, y agregarlo a la lista de rubros.
///
/// - `showingAddRubroPopover`: Bandera vinculada para mostrar u ocultar el popover de añadir rubro.
/// - `listaRubros`: El `RubroViewModel` que gestiona la lista de rubros.
/// - `rubroNombre`: El nombre del rubro a agregar o editar.
/// - `rubroValor`: El valor del rubro a agregar o editar.
/// - `showingAlert`: Bandera que indica si se debe mostrar una alerta en caso de error al agregar el rubro.
///
/// Esta vista permite agregar o editar rubros. También valida que la suma total de los valores de los rubros no exceda el 100%.

struct AddRubroButton: View {
    @Binding var showingAddRubroPopover: Bool
    @ObservedObject var listaRubros: RubroViewModel
    @Binding var rubroNombre: String
    @Binding var rubroValor: String
    @Binding var showingAlert: Bool
    
    var body: some View {
        Button {
            showingAddRubroPopover.toggle()
        } label: {
            Label("Añadir criterio", systemImage: "plus")
                .foregroundColor(.blue)
                .autocorrectionDisabled(true)
        }
        .disabled(totalRubroValue() >= 100)
        .popover(isPresented: $showingAddRubroPopover) {
            AddRubroPopoverView(
                rubroNombre: $rubroNombre,
                rubroValor: $rubroValor,
                onSave: addRubro
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Valor excedido"),
                    message: Text("El valor total de los rubros no puede exceder el 100%."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func addRubro() {
        if let valor = Double(rubroValor), totalRubroValue() + valor <= 100 {
            if let index = listaRubros.rubroList.firstIndex(where: { $0.nombre == rubroNombre }) {
                // Editar rubro existente
                
                listaRubros.rubroList[index].valor = valor
            }
            
            else {
                // Agregar un nuevo rubro
                let nuevoRubro = Rubro(nombre: rubroNombre, valor: valor)
                listaRubros.rubroList.append(nuevoRubro)
            }
            rubroNombre = ""
            rubroValor = ""
            showingAddRubroPopover = false
        } else {
            showingAlert = true
        }
    }
    
    private func totalRubroValue() -> Double {
        listaRubros.rubroList.reduce(0) { $0 + $1.valor }
    }
}
