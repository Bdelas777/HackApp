
//
//  AddHackView.swift
//  HackApp
//
//  Created by Alumno on 19/09/24.
//

import SwiftUI

struct AddHackView: View {
    @State var nombre: String = ""
    @State var descripcion: String = ""
    @State var numJueces: Int = 1
    @State var date: Date = Date.now
    @State var tiempoPitch: Double = 0.0
    @StateObject var listaRubros = RubroViewModel()
    @StateObject var listaEquipos = EquipoViewModel()
    @StateObject var listaJueces = JuezViewModel()
    @State private var showingAlert = false
    @ObservedObject var listaHacks: HacksViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var isFormValid: Bool {
        !nombre.isEmpty &&
        !descripcion.isEmpty &&
        tiempoPitch > 0 &&
        !listaRubros.rubroList.isEmpty
    }
    
    var body: some View {
        VStack {
            AddHackForm(
                nombre: $nombre,
                descripcion: $descripcion,
                numJueces: $numJueces,
                date: $date,
                tiempoPitch: $tiempoPitch,
                listaRubros: listaRubros,
                listaEquipos: listaEquipos,
                listaJueces: listaJueces,
                showingAlert: $showingAlert
            )
            Button {
                let nuevoHack = HackPrueba(
                    descripcion: descripcion,
                    equipos: listaEquipos.equipoList.map { $0.nombre }, // Map equipo names to array
                    jueces: listaJueces.juezList.reduce(into: [String: [String: Int]]()) { result, juez in
                        result[juez.nombre] = [:]
                    },
                    rubros: listaRubros.rubroList.reduce(into: [String: Double]()) { $0[$1.nombre] = $1.valor },
                    estaActivo: true,
                    nombre: nombre,
                    tiempoPitch: tiempoPitch,
                    Fecha: date // Ensure 'Fecha' matches your HackPrueba model
                )
                
                // Call the addHackPrueba function to save to Firestore
                listaHacks.addHackPrueba(hack: nuevoHack) { result in
                    switch result {
                    case .success:
                        presentationMode.wrappedValue.dismiss() // Dismiss if successful
                    case .failure(let error):
                        print("Error adding hack: \(error.localizedDescription)")
                        showingAlert = true // Show alert if there's an error
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

