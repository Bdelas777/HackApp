//
//  SimplePage.swift
//  HackApp
//
//  Created by Alumno on 09/10/24.
//
import SwiftUI

struct TeamView: View {
    var hack: HackPrueba
    @ObservedObject var viewModel = HacksViewModel()
    let equipoSeleccionado: String
    @State private var calificaciones: [String: [String: Double]] = [:]
    @State private var isLoading = true
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isRunning = false
    @State private var finalScores: [String: Double] = [:]
    @State private var totalScore: Double = 0.0
    @State private var rubros: [String: Double] = [:]
    @State private var totalJudges: Int = 0

    var body: some View {
        VStack {
            Text(equipoSeleccionado)
                .font(.largeTitle)
                .padding()

            if isLoading {
                ProgressView("Cargando calificaciones...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding()
            } else {
                if calificaciones.isEmpty {
                    TimerView(tiempoPitch: Int(hack.tiempoPitch))
                } else {
                  

                    List {
                        ForEach(calificaciones.keys.sorted(), id: \.self) { juez in
                            Section(header: Text(juez).font(.subheadline).foregroundColor(.gray)) {
                                ForEach(calificaciones[juez]?.keys.sorted() ?? [], id: \.self) { rubro in
                                    let calificacion = calificaciones[juez]?[rubro] ?? 0.0
                                    let pesoRubro = rubros[rubro] ?? 0.0
                                    let valorFinal = calculateFinalScore(calificacion: calificacion, peso: pesoRubro)

                                    VStack(alignment: .leading) {
                                        Text("\(rubro): \(String(format: "%.2f", calificacion))")
                                            .foregroundColor(.black)
                                        Text("Peso: \(String(format: "%.2f", pesoRubro))% | Valor Final: \(String(format: "%.2f", valorFinal))")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }

                    Text("Puntuación General: \(totalJudges > 0 ? String(format: "%.2f", totalScore / Double(totalJudges)) : "0.00")")
                        .font(.headline)
                        .padding()
                }
            }
        }
        .navigationTitle(calificaciones.isEmpty ? "Tiempo restante" : "Calificaciones")
        .onAppear {
            timeRemaining = TimeInterval(hack.tiempoPitch * 60)
            fetchRubros()
            fetchCalificaciones()
        }
    }
    
    private func calculateFinalScore(calificacion: Double, peso: Double) -> Double {
        return (calificacion * peso) / 100.0
    }

    private func accumulateScores() {
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

    private func fetchRubros() {
        viewModel.fetchRubros(for: hack.clave) { result in
            switch result {
            case .success(let rubrosData):
                self.rubros = rubrosData.mapValues { Double($0) }
            case .failure(let error):
                print("Error al obtener rubros: \(error)")
            }
        }
    }
    
    private func fetchCalificaciones() {
        viewModel.getCalificaciones(for: equipoSeleccionado, hackClave: hack.clave) { result in
            switch result {
            case .success(let calificaciones):
                self.calificaciones = calificaciones
                totalJudges = calificaciones.keys.count
                accumulateScores()
            case .failure(let error):
                print("Error al obtener calificaciones: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }
}

#Preview {
    TeamView(hack: HackPrueba(
        id: "Ejemplo Hack",
        clave: "Hack",
        descripcion: "Descripción del hack",
        equipos: ["P", "Q"],
        jueces: ["A", "B"],
        rubros: ["rubro": 50],
        estaActivo: true,
        nombre: "Ejemplo",
        tiempoPitch: 9,
        FechaStart: Date(),
        FechaEnd: Date(),
        valorRubro: 5,
        calificaciones: [
            "P": ["A": ["rubro": 9]],
            "Q": ["B": ["rubro": 78]]
        ]
    ), equipoSeleccionado: "Equipo 1")
}
