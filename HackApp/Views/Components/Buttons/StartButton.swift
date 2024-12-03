//
//  StartButton.swift
//  HackApp
//
//  Created by Alumno on 05/09/24.
//
import SwiftUI
/// Vista personalizada que crea un botón de inicio con un icono, título y una vista de destino.
/// Al presionar el botón, navega hacia la vista `destination` proporcionada.
///
/// - `title`: El título del botón, que se muestra debajo del icono.
/// - `iconName`: El nombre del sistema de icono de SF Symbols que se utiliza para representar el botón.
/// - `hint`: Una sugerencia accesible que describe el propósito del botón.
/// - `destination`: La vista hacia la cual se navegará al presionar el botón.
///
/// Esta vista proporciona un botón visualmente destacado con un icono y un título, y puede ser utilizado
/// para navegar hacia una nueva vista dentro de una `NavigationStack`.

struct StartButton<Destination: View>: View {
    var title: String
    var iconName: String
    var hint: String
    var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                VStack {
                    Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 90, height: 90)
                    
                    Text(title)
                        .foregroundColor(.white)
                        .font(.custom("Lato", size: 53))
                        .bold()
                        .frame(width: 330)
                }
                .frame(width: 500, height: 280)
                .background(Color("LightBlue"))
                .cornerRadius(30)
                .padding(5)
                .foregroundColor(.white)
            }
        }
        .accessibilityLabel(title)
        .accessibilityHint(hint)
    }
}

#Preview {
    NavigationStack {
        StartButton(
            title: "Button",
            iconName: "envelope.fill",
            hint: "Esto es un boton",
            destination: HomeAdminView()
        )
    }
}
