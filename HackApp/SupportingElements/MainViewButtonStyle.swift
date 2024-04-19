//
//  MainViewButtonStyle.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 19/04/24.
//

import Foundation
import SwiftUI

struct MainViewButtonStyle : ButtonStyle{
    func makeBody(configuration: Configuration) -> some View{
        configuration.label
            .padding()
            .background(Color.purple)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
