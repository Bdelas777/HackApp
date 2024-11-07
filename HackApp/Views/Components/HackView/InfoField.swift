//
//  InfoField.swift
//  HackApp
//
//  Created by Alumno on 07/11/24.
//
import SwiftUI

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
