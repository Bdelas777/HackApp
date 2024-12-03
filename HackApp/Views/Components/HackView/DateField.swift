//
//  DateField.swift
//  HackApp
//
//  Created by Alumno on 07/11/24.
//
import SwiftUI
// Vista que muestra un campo de fecha con un título y un `DatePicker`.
///
/// - `title`: Título que describe el campo de fecha.
/// - `date`: Fecha seleccionada vinculada a una variable externa mediante `@Binding`.
///
/// Esta vista permite que el usuario seleccione una fecha, mostrando un `DatePicker` con el formato estándar de fecha.
struct DateField: View {
    var title: String
    @Binding var date: Date
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            DatePicker("", selection: $date, displayedComponents: .date)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}
