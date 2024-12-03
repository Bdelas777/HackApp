//
//  ActionButtons.swift
//  HackApp
//
//  Created by Alumno on 07/11/24.
//

import SwiftUI

/// Vista que presenta tres botones de acción para un "Hack":
/// 1. Guardar cambios
/// 2. Ver resultados
/// 3. Cerrar el hack.
///
/// - `hack`: El modelo de datos que representa el hack actual.
/// - `saveChanges`: Acción para guardar los cambios del hack.
/// - `showCloseAlert`: Acción para mostrar una alerta antes de cerrar el hack.
/// - `showResults`: Acción para navegar a la vista de resultados del hack.
struct ActionButtons: View {
    var hack: HackModel
    var saveChanges: () -> Void
    var showCloseAlert: () -> Void
    var showResults: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            saveButton
            navigationLinkButton
            closeHackButton
        }
        .padding(.top, 20)
    }
    
    private var saveButton: some View {
        Button(action: saveChanges) {
            Text("Guardar Cambios")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(hack.estaActivo ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.green.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .disabled(!hack.estaActivo)
    }
    
    private var navigationLinkButton: some View {
        NavigationLink(destination: ResultsView(hack: hack)) {
            Text("Ver Resultados")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
    
    private var closeHackButton: some View {
        HStack {
            Spacer()
            Button(action: showCloseAlert) {
                Text("Cerrar Hack")
                    .font(.headline)
                    .padding()
                    .frame(width: 130)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.red.opacity(0.3), radius: 2, x: 0, y: 2)
            }
            .padding(.trailing, 20)
        }
    }
}
