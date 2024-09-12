//
//  HomeView.swift
//  HackApp
//
//  Created by Alumno on 06/09/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: HomeAdminView()) {
                    StartButton(
                        title: "Administrador",
                        iconName: "gear",
                        hint: "Botón de administrador",
                        action: {}
                    )
                }
                
                NavigationLink(destination: JudgeHomeView()) {
                    StartButton(
                        title: "Juez",
                        iconName: "person.crop.circle.fill.badge.checkmark",
                        hint: "Botón de juez",
                        action: {}
                    )
                }
            }
            .padding()
            .background(Color.white)
            .navigationTitle("Inicio")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


#Preview {
    HomeView()
}
