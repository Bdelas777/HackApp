//
//  HackRow.swift
//  HackApp
//
//  Created by Alumno on 24/09/24.
//

import SwiftUI

struct HackRow: View {
    var hack: HackPrueba
    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Clave: \(hack.clave)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text("Nombre: \(hack.nombre)")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("Descripción: \(hack.descripcion)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Fecha de Inicio: \(hack.FechaStart, formatter: dateFormatter)")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Text("Fecha de Fin: \(hack.FechaEnd, formatter: dateFormatter)")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Text(hack.estaActivo ? "Estado: Activo" : "Estado: Inactivo")
                        .font(.footnote)
                        .foregroundColor(hack.estaActivo ? .green : .red)
                        .bold()
                }
                Spacer()
                
                // Botón de eliminación
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.1), in: Circle())
                }
                .confirmationDialog("¿Estás seguro de eliminar este hackathon?", isPresented: $showDeleteConfirmation) {
                    Button("Eliminar", role: .destructive) {
                        // Llamar a la función de eliminación del ViewModel
                        // Por ejemplo: hackData.deleteHack(hackClave: hack.clave)
                    }
                    Button("Cancelar", role: .cancel) {}
                }
            }
            .padding()
            .background(hack.estaActivo ? Color.white : Color.gray.opacity(0.3)) // Fondo gris para hacks inactivos
            .cornerRadius(8)
            .shadow(radius: 3)
        }
        .padding(.vertical, 5)
        .overlay(
            Divider()
                .padding(.leading)
                .padding(.trailing, 10),
            alignment: .bottom
        )
    }

    // Formateador de fecha
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

#Preview {
    HackRow(hack: HackPrueba(
        clave: "Hack001",
        descripcion: "Descripción del hack",
        equipos: ["Equipo A", "Equipo B"],
        jueces: [],
        rubros: [:],
        estaActivo: false,
        nombre: "Hackathon Ejemplo",
        tiempoPitch: 5.0,
        FechaStart: Date(),
        FechaEnd: Date().addingTimeInterval(86400 * 5), // 5 días después
        valorRubro: 5
    ))
}
