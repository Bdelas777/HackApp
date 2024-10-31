//
//  HackAppApp.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 10/04/24.
//
import SwiftUI
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configura Firebase
        FirebaseApp.configure()
        return true
    }
}

@main
struct HackApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var viewModel = HacksViewModel() 

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .environmentObject(viewModel)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
