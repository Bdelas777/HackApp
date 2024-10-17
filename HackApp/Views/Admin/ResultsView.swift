//
//  ResultsView.swift
//  HackApp
//
//  Created by Alumno on 15/10/24.
//


import SwiftUI
import Charts

struct ResultsView: View {
    var hack: HackPrueba
    @ObservedObject var viewModel = HacksViewModel()
    
    @State private var scores: [String: Double] = [:] // Para almacenar los puntajes de los equipos
    @State private var topTeams: [(team: String, score: Double)] = []
    
    var body: some View {
        VStack {
            Text("Resultados del Hackathon")
                .font(.largeTitle)
                .padding()
            
            if topTeams.isEmpty {
                Text("No hay resultados disponibles.")
                    .padding()
            } else {
                Chart(topTeams, id: \.team) { team in
                    BarMark(
                        x: .value("Equipo", team.team),
                        y: .value("Puntuación", team.score)
                    )
                    .foregroundStyle(by: .value("Equipo", team.team))
                }
                .frame(height: 300)
                .padding()
                
                Text("Mejores Equipos")
                    .font(.title2)
                    .padding()
                
                ForEach(topTeams.prefix(3), id: \.team) { team in
                    HStack {
                        Text(team.team)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(format: "%.2f", team.score)) / 100")
                            .fontWeight(.bold)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            fetchScores()
        }
    }
    
   private func fetchScores() {
        viewModel.getScores(for: hack.clave) { result in
            switch result {
            case .success(let scores):
                // Asegúrate de que `scores` contenga todos los equipos
                self.scores = scores
                
                // Mapea los puntajes a tuplas y ordena
                self.topTeams = scores.map { (team: $0.key, score: $0.value) }
                    .sorted(by: { $0.score > $1.score })
                
            case .failure(let error):
                print("Error al obtener los puntajes: \(error)")
            }
        }
    }
}
