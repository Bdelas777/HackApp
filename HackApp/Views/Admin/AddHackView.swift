
//
//  AddHackView.swift
//  HackApp
//
//  Created by Alumno on 19/09/24.
//

import SwiftUI

struct AddHackView: View {
    @State var clave: String = ""
    @State var nombre: String = ""
    @State var descripcion: String = ""
    @State var date: Date = Date()
    @State var dateEnd: Date = Date()
    @State var valorRubro: String = ""
    @State var tiempoPitch: Double = 0.0
    @StateObject var listaRubros = RubroViewModel()
    @StateObject var listaEquipos = EquipoViewModel()
    @StateObject var listaJueces = JuezViewModel()
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @ObservedObject var listaHacks: HacksViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            AddHackForm(
                nombre: $nombre, clave: $clave,
                descripcion: $descripcion,
                date: $date,
                dateEnd: $dateEnd,
                valorRubro: $valorRubro,
                tiempoPitch: $tiempoPitch,
                listaRubros: listaRubros,
                listaEquipos: listaEquipos,
                listaJueces: listaJueces,
                showingAlert: $showingAlert
            )
            Button {
                validateAndSave()
            } label: {
                Text("Guardar")
            }
            .padding()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateAndSave() {
        // Validar fechas
        if date >= dateEnd {
            alertMessage = "La fecha de inicio no puede ser posterior a la fecha de fin."
            showingAlert = true
            return
        }
        
        // Validar suma de valores de rubros
        let totalRubroValue = listaRubros.rubroList.reduce(0) { $0 + $1.valor }
        if totalRubroValue < 100 {
            alertMessage = "La suma de los valores de los rubros debe ser al menos 100."
            showingAlert = true
            return
        }
        
        // Guardar hack
        let nuevoHack = HackPrueba(
            clave: clave,
            descripcion: descripcion,
            equipos: listaEquipos.equipoList.map { $0.nombre },
            jueces: listaJueces.juezList.map { $0.nombre },
            rubros: listaRubros.rubroList.reduce(into: [String: Double]()) { $0[$1.nombre] = $1.valor },
            estaActivo: true,
            nombre: nombre,
            tiempoPitch: tiempoPitch,
            FechaStart: date,
            FechaEnd: dateEnd,
            valorRubro: Int(valorRubro) ?? 0
        )
        
        listaHacks.addHack(hack: nuevoHack) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
                listaHacks.fetchHacks()
            case .failure(let error):
                alertMessage = "Error al guardar el hack: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}


#Preview {
    AddHackView(listaHacks: HacksViewModel())
}

