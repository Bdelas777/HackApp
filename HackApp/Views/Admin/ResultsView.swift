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
    
    @State private var scores: [String: Double] = [:]
    @State private var topTeams: [(team: String, score: Double)] = []
    
    var body: some View {
        VStack {
            Text("Resultados del Hackathon")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.primary)

            if topTeams.isEmpty {
                Text("No hay resultados disponibles.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Chart(topTeams, id: \.team) { team in
                    BarMark(
                        x: .value("Equipo", team.team),
                        y: .value("Puntuación", team.score)
                    )
                    .foregroundStyle(by: .value("Equipo", team.team))
                    .annotation(position: .top) {
                        Text(String(format: "%.1f", team.score))
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(2)
                            .background(Color.white)
                            .cornerRadius(5)
                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    }
                }
                .frame(height: 300)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                .chartXAxisLabel("Equipos")
                .chartYAxisLabel("Puntuación")
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                
                Text("Mejores Equipos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                ForEach(topTeams.prefix(3), id: \.team) { team in
                    HStack {
                        Text(team.team)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(String(format: "%.2f", team.score)) / \(hack.valorRubro)")
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            fetchScores()
        }
    }
    
    private func fetchScores() {
        viewModel.getScores(for: hack.clave) { result in
            switch result {
            case .success(let scores):
                self.scores = scores
                self.topTeams = scores.map { (team: $0.key, score: $0.value) }
                    .sorted(by: { $0.score > $1.score })
            case .failure(let error):
                print("Error al obtener los puntajes: \(error)")
            }
        }
    }
}
