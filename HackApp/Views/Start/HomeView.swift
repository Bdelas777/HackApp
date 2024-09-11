//
//  HomeView.swift
//  HackApp
//
//  Created by Alumno on 06/09/24.
//

import SwiftUI


struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            StartButton(title: "Administrador", iconName: "gear", hint: "Botón de administrador", action: {
                // Acción para el botón Administrador
            })
            
            StartButton(title: "Juez", iconName: "person.crop.circle.fill.badge.checkmark", hint: "Botón de juez", action: {
                // Acción para el botón Juez
            })
        }
        .padding()
        .background(Color.white)
        .navigationTitle("Inicio")
    }
}


struct JudgeView: View {
    var body: some View {
        Text("Vista de Juez")
            .font(.largeTitle)
            .padding()
    }
}


#Preview {
    HomeView()
}
