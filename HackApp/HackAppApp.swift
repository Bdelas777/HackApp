//
//  HackAppApp.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 10/04/24.
//

import SwiftUI


@main
struct HackApp: App {
    

    var body: some Scene {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

