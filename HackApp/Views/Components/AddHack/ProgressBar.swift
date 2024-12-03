//
//  ProgressBar.swift
//  HackApp
//
//  Created by Alumno on 03/12/24.
//
import SwiftUI

/// Vista que muestra una barra de progreso horizontal.
/// Utiliza un `ProgressView` de SwiftUI para representar el progreso en una barra lineal.
///
/// - `progress`: Un valor `CGFloat` entre 0 y 1 que indica el progreso actual de la barra.
///
/// Esta vista se utiliza para mostrar el avance de una tarea o proceso.
struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        ProgressView(value: progress, total: 1)
            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            .frame(height: 10)
            .padding([.leading, .trailing])
    }
}

