//
//  InfoFieldDouble.swift
//  HackApp
//
//  Created by Alumno on 07/11/24.
//
import SwiftUI

struct InfoFieldDouble: View {
    var title: String
    @Binding var value: Double
    
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
