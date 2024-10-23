
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
    @State var numJueces: Int = 1
    @State var date: Date = Date.now
    @State var dateEnd: Date = Date.now
    @State var valorRubro: String = ""
    @State var tiempoPitch: Double = 0.0
    @StateObject var listaRubros = RubroViewModel()
    @StateObject var listaEquipos = EquipoViewModel()
    @StateObject var listaJueces = JuezViewModel()
    @State private var showingAlert = false
    @ObservedObject var listaHacks: HacksViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var isFormValid: Bool {
        !nombre.isEmpty &&
        !clave.isEmpty &&
        !descripcion.isEmpty &&
        tiempoPitch > 0 &&
        !listaEquipos.equipoList.isEmpty &&
        !listaJueces.juezList.isEmpty &&
        !listaRubros.rubroList.isEmpty
    }
    
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
                let valorRubroInt = Int(valorRubro) ?? 0 

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
                    valorRubro: valorRubroInt // Use the converted integer
                )


               
                listaHacks.addHack(hack: nuevoHack) { result in
                    switch result {
                    case .success:
                        presentationMode.wrappedValue.dismiss()
                        listaHacks.fetchHacks()
                    case .failure(let error):
                        print("Error adding hack: \(error.localizedDescription)")
                        showingAlert = true
                    }
                }
            } label: {
                Text("Guardar")
            }
            .buttonStyle(MainViewButtonStyle(isEnabled: isFormValid))
            .disabled(!isFormValid)
            .padding()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Hubo un problema al guardar el hack."), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    AddHackView(listaHacks: HacksViewModel())
}

