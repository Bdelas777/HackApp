//
//  DateField.swift
//  HackApp
//
//  Created by Alumno on 07/11/24.
//
import SwiftUI

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
