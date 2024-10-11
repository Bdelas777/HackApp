//
//  SimplePage.swift
//  HackApp
//
//  Created by Alumno on 09/10/24.
//
import SwiftUI

struct TeamView: View {
    var hack: HackPrueba
    let equipoSeleccionado: String
    @State private var calificaciones: [String: [String: Double]] = [:]
    @State private var isLoading = true
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isRunning = false
    
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
                                    Text("\(rubro): \(calificaciones[juez]?[rubro] ?? 0.0)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(calificaciones.isEmpty ? "Tiempo restante" : "Calificaciones")
        .onAppear {
            timeRemaining = TimeInterval(hack.tiempoPitch * 60) // Convertir minutos a segundos
            fetchCalificaciones()
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
