//
//  HackRow.swift
//  HackApp
//
//  Created by Alumno on 24/09/24.
//
import SwiftUI

struct HackRow: View {
    var hack: HackModel
    @State private var showDeleteConfirmation = false
    @EnvironmentObject var viewModel: HacksViewModel

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Clave: \(hack.clave)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("Nombre: \(hack.nombre)")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Descripción:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text(hack.descripcion)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(2) // Limit to two lines for better spacing

                    HStack {
                        Text("Fecha de Inicio: \(hack.FechaStart, formatter: Self.dateFormatter)")
                            .font(.footnote)
                            .foregroundColor(.gray)

                        Spacer()

                        Text("Fecha de Fin: \(hack.FechaEnd, formatter: Self.dateFormatter)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()

                Button(action: { showDeleteConfirmation = true }) {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.red, in: Circle())
                }
                .confirmationDialog("¿Estás seguro de eliminar este hackathon?", isPresented: $showDeleteConfirmation) {
                    Button("Eliminar", role: .destructive) {
                        viewModel.deleteHack(withKey: hack.clave) { result in
                            switch result {
                            case .success:
                                print("Hackathon eliminado exitosamente.")
                                viewModel.fetchHacks()
                            case .failure(let error):
                                print("Error al eliminar hackathon: \(error.localizedDescription)")
                            }
                        }
                    }
                    Button("Cancelar", role: .cancel) {}
                }
            }
            .padding()
            .background(hack.estaActivo ? Color.white : Color.gray.opacity(0.15))
            .cornerRadius(12)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.vertical, 10)
        .overlay(
            Divider()
                .padding(.leading)
                .padding(.trailing, 10),
            alignment: .bottom
        )
    }
}
