//
//  MainViewButtonStyle.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 19/04/24.
//

import SwiftUI

struct MainViewButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isEnabled ? Color.purple : Color.gray)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1.0) // Slight opacity change when pressed
    }
}
