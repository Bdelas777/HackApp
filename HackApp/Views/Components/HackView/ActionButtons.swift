import SwiftUI

struct ActionButtons: View {
    var hack: HackModel
    var showCloseAlert: () -> Void
    var showResults: () -> Void
    var startHack: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            navigationLinkButton
            closeAndStartButtons
        }
        .padding(.top, 20)
    }
    
    
    private var navigationLinkButton: some View {
        NavigationLink(destination: ResultsView(hack: hack)) {
            Text("Ver Resultados")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
    
    private var closeAndStartButtons: some View {
        HStack(spacing: 15) {
            // Cerrar Hack Button
            Button(action: showCloseAlert) {
                Text("Cerrar Hack")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity) // Esto asegura que el botón ocupe la mitad
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.red.opacity(0.3), radius: 2, x: 0, y: 2)
            }
            .disabled(!hack.estaActivo) // Deshabilitar si ya está iniciado
            
            // Iniciar Hack Button
            Button(action: startHack) {
                Text("Iniciar Hack")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity) // Esto asegura que el botón ocupe la mitad
                    .background(hack.estaIniciado ? Color.gray: Color.blue )
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .disabled(hack.estaIniciado)
        }
        .padding(.horizontal)
    }
}
