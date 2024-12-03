//
//  InfoField.swift
//  HackApp
//
//  Created by Alumno on 07/11/24.
//
import SwiftUI

/// Vista que muestra un campo de texto con un título para ingresar un valor de tipo `String`.
/// Utiliza un `TextField` para permitir la entrada de texto.
///
/// - `title`: El título que describe el campo de texto.
/// - `text`: El valor `String` vinculado mediante `@Binding` que se actualiza con la entrada del usuario.
///
/// Esta vista es útil para ingresar y editar valores de texto.
struct InfoField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            TextField(title, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}
