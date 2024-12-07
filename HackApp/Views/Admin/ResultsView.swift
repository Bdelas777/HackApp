import SwiftUI
import Charts

struct ResultsView: View {
    var hack: HackModel
    @ObservedObject var viewModel = HacksViewModel()
    @State private var scores: [String: Double] = [:]
    @State private var calificacionesPorCriterio: [String: [String: Double]] = [:]
    @State private var topTeams: [(team: String, score: Double)] = []
    @State private var topTeamsPorCriterio: [(team: String, score: Double)] = []
    @State private var isLoading: Bool = true
    @State private var selectedCriterio: String? = nil
    
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
            } else {
                // Picker para seleccionar entre resultados generales o calificaciones por criterio
                Picker("Seleccionar tipo de resultado", selection: $selectedCriterio) {
                    Text("Score General").tag(nil as String?)
                    ForEach(calificacionesPorCriterio.keys.sorted(), id: \.self) { criterio in
                        Text(criterio).tag(criterio as String?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedCriterio) { _ in
                    updateTopTeamsPorCriterio() // Actualizamos los equipos por criterio cada vez que se cambia la selección
                }

                // Envolvemos la gráfica en un ScrollView vertical para hacerla desplazable
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        // Mostrar gráfico de barras
                        if let criterio = selectedCriterio {
                            // Mostrar calificaciones por criterio
                            if let calificaciones = calificacionesPorCriterio[criterio] {
                                Chart(calificaciones.keys.sorted(), id: \.self) { equipo in
                                    BarMark(
                                        x: .value("Puntuación", calificaciones[equipo] ?? 0.0),
                                        y: .value("Equipo", equipo)
                                    )
                                    .foregroundStyle(by: .value("Equipo", equipo))
                                    .annotation(position: .top) {
                                        Text(String(format: "%.1f", calificaciones[equipo]!))
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
                            }
                        } else {
                            // Mostrar los resultados generales (finalScores)
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
                        }
                    }
                }
                .padding()
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
                                Text("\(String(format: "%.2f", rankedGroup.score)) / \(String(format: "%.2f", Double(hack.valorRubro)))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.accentColor)
                            }
                            .padding()
                            .background(getBackgroundColor(for: rankedGroup.team, rank: rankedGroup.rank))
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
            updateTopTeamsPorCriterio()
        }
    }

    func fetchScores() {
        // Obtener los puntajes generales
        viewModel.getScores(for: hack.clave) { result in
            isLoading = false
            switch result {
            case .success(let scores):
                print("Puntajes generales obtenidos: \(scores)")
                self.scores = scores
                self.topTeams = scores.map { (team: $0.key, score: $0.value) }
                    .sorted(by: { $0.score > $1.score })
            case .failure(let error):
                print("Error al obtener los puntajes: \(error)")
            }
        }

        // Obtener las calificaciones por criterio
        viewModel.getCalificacionesPorCriterio(for: hack.clave) { result in
            switch result {
            case .success(let calificacionesPorCriterio):
                print("Calificaciones por criterio obtenidas: \(calificacionesPorCriterio)")
                self.calificacionesPorCriterio = calificacionesPorCriterio
                self.updateTopTeamsPorCriterio()
            case .failure(let error):
                print("Error al obtener las calificaciones por criterio: \(error)")
            }
        }
    }

    private func updateTopTeamsPorCriterio() {
        guard let criterioSeleccionado = selectedCriterio, !criterioSeleccionado.isEmpty else {
            return
        }

        let calificaciones = calificacionesPorCriterio[criterioSeleccionado] ?? [:]
        topTeamsPorCriterio = calificaciones.map { (team: $0.key, score: $0.value) }
            .sorted(by: { $0.score > $1.score })
    }
    
    private func getRankedTeams() -> [(team: String, score: Double, rank: Int)] {
        var rankedTeams: [(team: String, score: Double)] = []
        var currentRank = 1
        var currentScore: Double? = nil
        var sameRankTeams: [(team: String, score: Double)] = []
        
        let teamsToRank = selectedCriterio != nil ? topTeamsPorCriterio : topTeams
        
        for team in teamsToRank {
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

    private func getBackgroundColor(for team: String, rank: Int) -> Color {
        guard let score = scores[team], score > 0 else {
            // Si no tiene calificación (score <= 0), ponemos color gris
            return Color.gray.opacity(0.3)
        }

        switch rank {
        case 1:
            return Color.yellow.opacity(0.6)   // Oro para el primer lugar
        case 2:
            return Color.gray.opacity(0.6)      // Plata para el segundo lugar
        case 3:
            return Color.brown.opacity(0.6)     // Bronce para el tercer lugar
        default:
            return Color.green.opacity(0.3)    // Verde para otros equipos calificados
        }
    }
}
