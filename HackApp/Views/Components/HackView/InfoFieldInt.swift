//
//  InfoFieldInt.swift
//  HackApp
//
//  Created by Alumno on 07/11/24.
//
import SwiftUI

/// Vista que muestra un campo de texto para ingresar un valor `Int` con un título.
/// Utiliza un `TextField` para permitir la entrada de números enteros.
///
/// - `title`: El título que describe el campo de valor.
/// - `value`: El valor `Int` vinculado mediante `@Binding` que se actualiza con la entrada del usuario.
///
/// Esta vista es útil para ingresar y editar valores enteros.
struct InfoFieldInt: View {
    var title: String
    @Binding var value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            TextField(title, value: $value, formatter: NumberFormatter())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}
