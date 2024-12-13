
import SwiftUI
/// Vista principal que presenta la pantalla de inicio con botones para navegar a diferentes vistas,
/// como la vista de "Administrador" y "Juez".
///
/// Esta vista utiliza `StartButton` para mostrar botones destacados con iconos y títulos, y permite
/// la navegación hacia otras vistas del aplicativo al presionar los botones.
///
/// - Se utilizan dos botones: uno para acceder a la vista de "Administrador" y otro para acceder a la vista de "Juez".

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                StartButton(
                    title: "Administrador",
                    iconName: "gear",
                    hint: "Botón de administrador",
                    destination: HomeAdminView() 
                    
                )

                StartButton(
                    title: "Juez",
                    iconName: "person.crop.circle.fill.badge.checkmark",
                    hint: "Botón de juez",
                    destination: JudgesView()
                )
            }
            .padding()
            .background(Color.white)
            .navigationTitle("Inicio")
            .edgesIgnoringSafeArea(.all) 
        }
    }
}

#Preview {
    HomeView()
}
