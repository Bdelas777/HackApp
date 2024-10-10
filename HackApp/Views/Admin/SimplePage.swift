//
//  SimplePage.swift
//  HackApp
//
//  Created by Alumno on 09/10/24.
//
import SwiftUI

struct SimplePage: View {
    var hack: HackPrueba
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isRunning: Bool = false
    let equipoSeleccionado: String

    var body: some View {
        VStack {
            Text(hack.nombre)
                .font(.largeTitle)
                .padding()

            if hack.calificaciones == [:]{

                TimerView(tiempoPitch: Int(hack.tiempoPitch))
            } else {
                // Display the ratings if available
                Text("Calificaciones:")
                    .font(.headline)
                    .padding()

                List {
                    
                }
            }
        }
        .navigationTitle("Calificaciones")
        .onAppear {
            timeRemaining = TimeInterval(hack.tiempoPitch * 60) // Convert minutes to seconds
        }
    }
}

struct TimerView: View {
    @State private var timeRemaining: TimeInterval
    @State private var isRunning: Bool = false
    @State private var timer: Timer?

    init(tiempoPitch: Int) {
        self._timeRemaining = State(initialValue: TimeInterval(tiempoPitch * 60))
    }

    var body: some View {
        VStack {
            Text(formattedTime())
                .font(.largeTitle)
                .bold()
                .padding()

            Button(action: {
                isRunning.toggle()
                if isRunning {
                    startTimer()
                } else {
                    stopTimer()
                }
            }) {
                Image(systemName: isRunning ? "stop.fill" : "play.fill")
                    .frame(width: 50, height: 50)
                    .font(.largeTitle)
            }
        }
    }

    private func formattedTime() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timeRemaining = 0
    }
}

#Preview {
    SimplePage(hack: HackPrueba(
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
    ),  equipoSeleccionado : "Equipo 1")
}
