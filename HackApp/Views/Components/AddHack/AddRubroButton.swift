//
//  AddRubroButton.swift
//  HackApp
//
//  Created by Alumno on 12/09/24.
//

import SwiftUI

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
            Label("Añadir rubro", systemImage: "plus")
                .foregroundColor(.blue)
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
            let nuevoRubro = Rubro( nombre: rubroNombre, valor: valor)
            listaRubros.rubroList.append(nuevoRubro)
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


