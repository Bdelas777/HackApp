//
//  JudgeHomeView.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 01/05/24.
//

import SwiftUI
struct JudgeHomeView: View {
    let hackClaveInput: String
    let selectedJudge: String
    let nombreHack: String
    let isActive: Bool
    @State private var selectedEquipos: [String]?
    @ObservedObject var viewModel = HacksViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if let equipos = selectedEquipos, !equipos.isEmpty {
                    ForEach(equipos, id: \.self) { equipo in
                        NavigationLink(destination: GradeView(hackClaveInput: hackClaveInput, selectedEquipo: equipo, nombreJuez: selectedJudge, isActive: isActive)) {
                            Text(equipo)
                                .font(.title)
                                .fontWeight(.medium)
                                .padding()
                            
                        }
                    }
                } else {
                    Text("No hay equipos disponibles.")
                        .font(.title)
                        .padding()
                }
            }
            .navigationTitle("Equipos de \(nombreHack)")
            .onAppear {
                fetchEquipos()
            }
        }
    }

    private func fetchEquipos() {
        viewModel.getEquipos(for: hackClaveInput) { result in
            switch result {
            case .success(let equipos):
                selectedEquipos = equipos.isEmpty ? nil : equipos
            case .failure:
                selectedEquipos = nil // Manejo opcional de errores
            }
        }
    }
}


struct JudgeHomeView_Previews: PreviewProvider {
    static var previews: some View {
        JudgeHomeView(hackClaveInput: "HACK24", selectedJudge: "Juez1", nombreHack:"ejemplo", isActive: false )
    }
}
