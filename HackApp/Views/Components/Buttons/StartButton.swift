//
//  StartButton.swift
//  HackApp
//
//  Created by Alumno on 05/09/24.
//
import SwiftUI

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
