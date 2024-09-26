//
//  HackInputModal.swift
//  HackApp
//
//  Created by Alumno on 25/09/24.
//


import SwiftUI

struct HackInputModal: View {
    @Binding var isPresented: Bool
    @Binding var hackName: String
    @ObservedObject var viewModel: HacksViewModel
    @State private var selectedHack: HackPrueba?

    var body: some View {
        VStack {
            Text("Ingrese el nombre del Hackathon")
                .font(.headline)
                .padding()

            TextField("Nombre del hack", text: $hackName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Aceptar") {
                if let hack = viewModel.hacks.first(where: { $0.nombre == hackName }) {
                    selectedHack = hack
                    isPresented = false
                    // Aquí puedes manejar la navegación a la vista de jueces
                } else {
                    alertHackNotFound()
                }
            }
            .padding()

            Button("Cancelar") {
                isPresented = false
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }

    private func alertHackNotFound() {
        // Implementa la lógica para mostrar una alerta
        print("El hack no existe.") // Reemplaza esto con tu lógica de alerta
    }
}

