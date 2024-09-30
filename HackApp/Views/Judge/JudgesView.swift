//
//  JudgesView.swift
//  HackApp
//
//  Created by Alumno on 25/09/24.
//
import SwiftUI

struct JudgesView: View {
    @State private var showModal = false
    @State private var hackNameInput = ""
    @State private var selectedJudges: [String: [String: Int]]?
    @State private var errorMessage: String?
    @State private var hasSearched = false
    @ObservedObject var viewModel = HacksViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let judges = selectedJudges {
                    Text("Escoge tu nombre:")
                        .font(.title)
                        .padding()
                    List(judges.keys.sorted(), id: \.self) { judge in
                        NavigationLink(destination: JudgeHomeView()){
                            Text(judge)
                                .font(.title2)
                                .padding()
                        }
                    }
                } else if hasSearched {
                    Text(errorMessage ?? "No se encontró ese hack.")
                        .foregroundColor(.red)
                        .font(.title)
                        .padding()
                } else {
                    Text("Realiza una búsqueda del hackathon.")
                        .font(.title)
                        .padding()
                }

                Spacer()
                
                Button {
                    showModal.toggle()
                } label: {
                    Label("Buscar Hackathon", systemImage: "search")
                        .font(.title)
                        .bold()
                        .padding()
                        .foregroundColor(.blue)
                }
                .popover(isPresented: $showModal) {
                    VStack(spacing: 20) {
                        TextField("Ingrese el nombre del Hack", text: $hackNameInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button(action: {
                            fetchJudges()
                            showModal = false
                        }) {
                            Text("Buscar Jueces")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .padding()
                    .frame(width: 300)
                }
            }
            .onAppear {
                viewModel.fetchHacks()
            }
        }
    }

    private func fetchJudges() {
        viewModel.getJudges(for: hackNameInput.lowercased()) { result in
            switch result {
            case .success(let judges):
                if judges.isEmpty {
                    selectedJudges = nil
                    errorMessage = "No se han encontrado jueces para el hack."
                } else {
                    selectedJudges = judges
                    errorMessage = nil
                }
                hasSearched = true
            case .failure:
                selectedJudges = nil
                errorMessage = "No se ha encontrado ese hack."
                hasSearched = true
            }
        }
    }
}


struct JudgesView_Previews: PreviewProvider {
    static var previews: some View {
        JudgesView()
    }
}
