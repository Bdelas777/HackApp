//
//  TimerView.swift
//  HackApp
//
//  Created by Alumno on 11/10/24.
//
import SwiftUI
import Charts
/// Vista que muestra un temporizador interactivo con un círculo de progreso.
/// Permite iniciar, detener y visualizar el tiempo restante en formato `mm:ss`.
///
/// - `tiempoPitch`: El tiempo inicial en minutos que define el valor total del temporizador.
///
/// Esta vista se utiliza para mostrar un temporizador circular con controles de reproducción y pausa.
struct TimerView: View {
    @State private var timeRemaining: TimeInterval
    @State private var isRunning: Bool = false
    @State private var timer: Timer?

    init(tiempoPitch: Int) {
        self._timeRemaining = State(initialValue: TimeInterval(tiempoPitch * 60))
    }

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .padding()
                Circle()
                    .trim(from: 0, to: CGFloat(1 - (timeRemaining / (60 * 9)))) // Ajusta el tiempo total según sea necesario
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))
                    .padding()
                Text(formattedTime())
                    .font(.largeTitle)
                    .bold()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
