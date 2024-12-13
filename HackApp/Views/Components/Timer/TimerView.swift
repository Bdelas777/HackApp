import SwiftUI
import AVFoundation

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
    @State private var player: AVAudioPlayer?

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
                    .trim(from: 0, to: CGFloat(1 - (timeRemaining / (60 * 9))))
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
        .onAppear {
            if let savedTime = UserDefaults.standard.value(forKey: "savedTimeRemaining") as? TimeInterval {
                self.timeRemaining = savedTime
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
                playSound()
            }
        }
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        UserDefaults.standard.set(timeRemaining, forKey: "savedTimeRemaining")
    }

    private func playSound() {
        guard let url = Bundle.main.url(forResource: "bell", withExtension: "mp3") else {
            print("No se pudo encontrar el archivo de sonido.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("No se pudo reproducir el sonido: \(error.localizedDescription)")
        }
    }
}
