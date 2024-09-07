//
//  HomeView.swift
//  HackApp
//
//  Created by Alumno on 06/09/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        StartButton(title: "Administrador", iconName: "gear", hint: "Boton de administrador", action: {})
        
        StartButton(title: "Juez", iconName: "person.crop.circle.fill.badge.checkmark", hint: "Boton de administrador", action: {})
    }
}

#Preview {
    HomeView()
}
