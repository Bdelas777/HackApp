//
//  AppDelegate.swift
//  HackApp
//
//  Created by Alumno on 13/09/24.
//

import UIKit
import Firebase


class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configura Firebase
        FirebaseApp.configure()
        
        return true
    }



    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Usa esta función para crear la configuración para las nuevas escenas.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Aquí puedes liberar los recursos asociados con las escenas descartadas.
    }
}
