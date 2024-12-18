
import SwiftUI
import Foundation

/// `TeamViewModel` es un modelo de vista que gestiona los datos de calificación y rubros de un equipo en un hackathon.
/// Esta clase se encarga de recuperar las calificaciones de los jueces, calcular las puntuaciones finales y gestionar los rubros de evaluación.
class TeamViewModel: ObservableObject {
    @Published var calificaciones: [String: [String: Double]] = [:]
    @Published var rubros: [String: Double] = [:]
    @Published var totalScore: Double = 0.0
    @Published var totalJudges: Int = 0
    @Published var isLoading: Bool = true

    private var hack: HackModel
    private var equipoSeleccionado: String
    private var viewModel: HacksViewModel

    init(hack: HackModel, equipoSeleccionado: String, viewModel: HacksViewModel) {
        self.hack = hack
        self.equipoSeleccionado = equipoSeleccionado
        self.viewModel = viewModel
    }

    func fetchRubros() {
        viewModel.fetchRubros(for: hack.clave) { result in
            switch result {
            case .success(let rubrosData):
                self.rubros = rubrosData.mapValues { Double($0) }
            case .failure(let error):
                print("Error al obtener rubros: \(error)")
            }
        }
    }

    func fetchCalificaciones() {
        viewModel.getCalificaciones(for: equipoSeleccionado, hackClave: hack.clave) { result in
            switch result {
            case .success(let calificaciones):
                self.calificaciones = calificaciones
                self.totalJudges = calificaciones.keys.count
                self.accumulateScores()
            case .failure(let error):
                print("Error al obtener calificaciones: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }

    func accumulateScores() {
        totalScore = 0.0
        for juez in calificaciones.keys {
            if let rubrosDelJuez = calificaciones[juez] {
                for rubro in rubrosDelJuez.keys {
                    let calificacion = rubrosDelJuez[rubro] ?? 0.0
                    let pesoRubro = rubros[rubro] ?? 0.0
                    let valorFinal = calculateFinalScore(calificacion: calificacion, peso: pesoRubro)
                    
                    totalScore += valorFinal
                }
            }
        }
    }

    func calculateFinalScore(calificacion: Double, peso: Double) -> Double {
        return (calificacion * peso) / 100
    }
}
