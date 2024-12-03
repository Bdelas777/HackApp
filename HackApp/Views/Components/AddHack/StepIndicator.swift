//
//  StepIndicator.swift
//  HackApp
//
//  Created by Alumno on 03/12/24.
//

import SwiftUI

/// Vista que muestra un indicador de pasos en un proceso o flujo.
/// Permite mostrar una lista de pasos, resaltar el paso actual y navegar entre ellos al hacer clic.
///
/// - `currentStep`: El índice del paso actual.
/// - `totalSteps`: El número total de pasos en el proceso.
/// - `steps`: Un arreglo de cadenas que representa los nombres o descripciones de los pasos.
/// - `onStepSelected`: Un cierre que se ejecuta cuando un paso es seleccionado, pasando el índice del paso seleccionado.
///
/// Esta vista presenta una serie de botones y círculos que representan los pasos de un proceso.
/// El paso actual está resaltado, y los usuarios pueden navegar entre los pasos haciendo clic en ellos.
struct StepIndicator: View {
    var currentStep: Int
    var totalSteps: Int
    var steps: [String]
    var onStepSelected: (Int) -> Void
    
    var body: some View {
        HStack {
            ForEach(0..<totalSteps, id: \.self) { step in
                VStack {
                    Button(action: {
                        onStepSelected(step)  // Cambiar el paso cuando se haga clic en la sección
                    }) {
                        Text(steps[step])
                            .font(.footnote)
                            .foregroundColor(currentStep == step ? .blue : .gray)
                            .padding(5)
                    }
                    .buttonStyle(PlainButtonStyle()) // Evita que el botón se vea con un estilo predeterminado
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(currentStep >= step ? .blue : .gray)
                }
                if step < totalSteps - 1 {
                    Spacer()
                }
            }
        }
        .padding()
    }
}
