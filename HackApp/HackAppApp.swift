//
//  HackAppApp.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 10/04/24.
//

import SwiftUI
import SwiftData

@main
struct HackApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

