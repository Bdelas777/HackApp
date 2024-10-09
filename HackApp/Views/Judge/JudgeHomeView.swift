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
    @State private var selectedEquipos: [String]?
    @ObservedObject var viewModel = HacksViewModel()
    let nombreHack = "HackMTY 2024"
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    List {
                        ForEach(selectedEquipos ?? [], id: \.self) { equipo in
                            NavigationLink(destination: GradeView(hackClaveInput: hackClaveInput, selectedEquipo: equipo, nombreJuez: selectedJudge ?? "")) {
                                Text(equipo)
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .padding()
                            }
                        }
                    }
                    .listRowSpacing(10)
                }
            }
            .navigationTitle("Equipos de \(nombreHack)")
        }
        .onAppear {
            fetchEquipos()
        }
    }

    private func fetchEquipos() {
        viewModel.getEquipos(for: hackClaveInput) { result in
            switch result {
            case .success(let equipos):
                if equipos.isEmpty {
                    selectedEquipos = nil
                } else {
                    selectedEquipos = equipos
                }
            case .failure:
                selectedEquipos = nil
            }
        }
    }
}

struct JudgeHomeView_Previews: PreviewProvider {
    static var previews: some View {
        JudgeHomeView(hackClaveInput: "HACK24", selectedJudge: "Juez1")
    }
}
