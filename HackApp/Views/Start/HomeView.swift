//
//  HomeView.swift
//  HackApp
//
//  Created by Alumno on 06/09/24.
//

import SwiftUI

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
