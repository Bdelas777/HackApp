//
//  JudgesView.swift
//  HackApp
//
//  Created by Alumno on 25/09/24.
//

import SwiftUI

struct JudgesView: View {
    @State private var showModal = true // Show modal by default
    @State private var hackNameInput = ""
    @State private var selectedHack: HackPrueba?
    @State private var errorMessage: String?

    @ObservedObject var viewModel = HacksViewModel()

    var body: some View {
        VStack {
            Button(action: {
                showModal.toggle()
            }) {
                Text("Buscar Jueces por Hack")
            }
            .sheet(isPresented: $showModal) {
                VStack {
                    TextField("Ingrese el nombre del Hack", text: $hackNameInput)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        fetchHack()
                    }) {
                        Text("Buscar Jueces")
                    }
                    .padding()
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else if let hack = selectedHack {
                        Text("Hack encontrado: \(hack.nombre)")
                            .padding()
                        
                        List(hack.jueces.keys.sorted(), id: \.self) { judge in
                            Text(judge)
                        }
                    } else {
                        Text("Esperando búsqueda...")
                            .padding()
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchHacks()
        }
    }

    private func fetchHack() {
        if let hack = viewModel.hacks.first(where: { $0.nombre.lowercased() == hackNameInput.lowercased() }) {
            selectedHack = hack
            print(hack)
            errorMessage = nil
        } else {
            selectedHack = nil
            errorMessage = "No existe un hack con ese nombre."
        }
    }
}
