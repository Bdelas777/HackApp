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
    @State private var isLoading: Bool = true // Loading state

    var body: some View {
        VStack {
            Text("Resultados del Hackathon")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.primary)
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .shadow(radius: 5)

            if isLoading {
                ProgressView("Cargando resultados...")
                    .padding()
            } else if topTeams.isEmpty || topTeams.allSatisfy({ $0.score <= 0 }) {
                Text("No hay resultados disponibles.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Chart(topTeams, id: \.team) { team in
                    BarMark(
                        x: .value("Puntuación", team.score),
                        y: .value("Equipo", team.team)
                    )
                    .foregroundStyle(by: .value("Equipo", team.team))
                    .annotation(position: .top) {
                        Text(String(format: "%.1f", team.score))
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .shadow(color: Color.black.opacity(0.1), radius: 1)
                    }
                }
                .frame(height: 500)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 8)
                .chartXAxisLabel("Puntuación")
                .chartYAxisLabel("Equipos")
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                
                Text("Mejores Equipos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                // Show more teams (e.g., top 20)
                let columns = Array(repeating: GridItem(.flexible()), count: 4)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(topTeams.prefix(20), id: \.team) { team in // Show top 20 teams
                        NavigationLink(destination: TeamView(hack: hack, equipoSeleccionado: team.team)) {
                            HStack {
                                Text(team.team)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(String(format: "%.2f", team.score)) / 100")
                                    .fontWeight(.bold)
                                    .foregroundColor(.accentColor)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 4)
                        }
                    }
                }
                .padding(.horizontal)
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
            isLoading = false
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
