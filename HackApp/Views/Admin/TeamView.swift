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
    @State private var generalScore: Double = 0.0
    @State private var rubros: [String: Double] = [:]
    var body: some View {
        VStack {
            Text(equipoSeleccionado)
                .font(.largeTitle)
                .padding()

            if isLoading {
                ProgressView("Cargando calificaciones...")
            } else {
                if calificaciones.isEmpty {
                   
                    TimerView(tiempoPitch: Int(hack.tiempoPitch))
                } else {
                    Text("Calificaciones:")
                        .font(.headline)
                        .padding()
                    
                    List {
                        ForEach(calificaciones.keys.sorted(), id: \.self) { juez in
                            Section(header: Text(juez)) {
                                ForEach(calificaciones[juez]?.keys.sorted() ?? [], id: \.self) { rubro in
                                    let calificacion = calificaciones[juez]?[rubro] ?? 0.0
                                    let pesoRubro = rubros[rubro] ?? 0.0
                                    
                                    let valorFinal = calculateFinalScore(calificacion: calificacion, peso: pesoRubro)

                                    Text("\(rubro): \(calificacion) Valor del rubro: \(pesoRubro) % (Valor Final: \(valorFinal ))")
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                   // calculateGeneralScore()
                    //Text("Puntuación General: \(generalScore, specifier: "%.2f")")
                        //                    .font(.headline)
                         //                   .padding()
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

        private func calculateGeneralScore() {
            //let totalJudges = finalScores.count
            //let totalScore = finalScores.values.reduce(0, +)
            //generalScore = totalJudges > 0 ? totalScore / Double(totalJudges) : 0.0
        }
    
    private func fetchRubros() {
        viewModel.fetchRubros(for: hack.clave) { result in
            switch result {
            case .success(let rubrosData):
                self.rubros = rubrosData.mapValues { Double($0) }
                print(rubros)
            case .failure(let error):
                print("Error al obtener rubros: \(error)")
            }
        }
    }
    
    private func fetchCalificaciones() {
        let viewModel = HacksViewModel()
        viewModel.getCalificaciones(for: equipoSeleccionado, hackClave: hack.clave) { result in
            switch result {
            case .success(let calificaciones):
                self.calificaciones = calificaciones
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
        Fecha: Date(),
        calificaciones: [
            "P": ["A": ["rubro": 9]],
            "Q": ["B": ["rubro": 78]]
        ]
    ),  equipoSeleccionado: "Equipo 1")
}
