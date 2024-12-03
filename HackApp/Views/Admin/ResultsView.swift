//
//  ResultsView.swift
//  HackApp
//
//  Created by Alumno on 15/10/24.
//
import SwiftUI
import Charts
/// Muestra los resultados del hackathon con las puntuaciones de los equipos.
/// Incluye un gráfico de barras y una lista de los mejores equipos.
///
/// **Propiedades**:
/// - `hack`: Detalles del hackathon.
/// - `viewModel`: Para obtener los puntajes.
/// - `scores`: Puntuaciones de los equipos.
/// - `topTeams`: Equipos ordenados por puntaje.
/// - `isLoading`: Indica si los datos están cargando.

struct ResultsView: View {
    var hack: HackModel
    @ObservedObject var viewModel = HacksViewModel()
    
    @State private var scores: [String: Double] = [:]
    @State private var topTeams: [(team: String, score: Double)] = []
    @State private var isLoading: Bool = true

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

                    
                }
                Text("Mejores Equipos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(getRankedTeams(), id: \.team) { rankedGroup in
                            NavigationLink(destination: TeamView(hack: hack, equipoSeleccionado: rankedGroup.team)) {
                                HStack {
                                    Text(rankedGroup.team)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("\(String(format: "%.2f", rankedGroup.score)) / 100")
                                        .fontWeight(.bold)
                                        .foregroundColor(.accentColor)
                                }
                                .padding()
                                .background(getBackgroundColor(for: rankedGroup.rank))
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
            .navigationTitle("Resultados del Hackathon")
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

    private func getRankedTeams() -> [(team: String, score: Double, rank: Int)] {
        var rankedTeams: [(team: String, score: Double)] = []
        var currentRank = 1
        var currentScore: Double? = nil
        var sameRankTeams: [(team: String, score: Double)] = []
        
        for team in topTeams {
            if currentScore == nil || team.score == currentScore {
                sameRankTeams.append(team)
                currentScore = team.score
            } else {
                rankedTeams.append(contentsOf: sameRankTeams)
                sameRankTeams = [team]
                currentRank += sameRankTeams.count
                currentScore = team.score
            }
        }
        rankedTeams.append(contentsOf: sameRankTeams)
        
        return rankedTeams.enumerated().map { (index, team) in
            (team: team.team, score: team.score, rank: index + 1)
        }
    }

    private func getBackgroundColor(for rank: Int) -> Color {
        switch rank {
        case 1:
            return Color.yellow.opacity(0.6)
        case 2:
            return Color.gray.opacity(0.6)
        case 3:
            return Color.brown.opacity(0.6)
        default:
            return Color(.systemGray6)
        }
    }
}
