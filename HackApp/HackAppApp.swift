//
//  HackAppApp.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 10/04/24.
//

import SwiftUI
import SwiftData

@main
struct HackAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(StackNavigationViewStyle()) // Forza el estilo de pila
        }
    }
}

