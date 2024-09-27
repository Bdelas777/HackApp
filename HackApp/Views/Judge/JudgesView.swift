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
    @State private var selectedJudges: [String: [String: Int]]?
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
                        fetchJudges()
                    }) {
                        Text("Buscar Jueces")
                    }
                    .padding()
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else if let judges = selectedJudges {
                        Text("Jueces encontrados:")
                            .padding()
                        
                        List(judges.keys.sorted(), id: \.self) { judge in
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

    private func fetchJudges() {
        viewModel.getJudges(for: hackNameInput.lowercased()) { result in
            switch result {
            case .success(let judges):
                selectedJudges = judges
                errorMessage = nil
                print("Jueces encontrados: \(judges)")
            case .failure(let error):
                selectedJudges = nil
                errorMessage = "Error al obtener los jueces: \(error.localizedDescription)"
            }
        }
    }
}

struct JudgesView_Previews: PreviewProvider {
    static var previews: some View {
        JudgesView()
    }
}

