//
//  HackRow.swift
//  HackApp
//
//  Created by Alumno on 24/09/24.
//

import SwiftUI

struct HackRow: View {
    var hack: HackPrueba

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(hack.clave)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(hack.nombre)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(hack.descripcion)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(hack.FechaStart, style: .date)
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Text(hack.FechaEnd , style: .date)
                    .font(.footnote)
                    .foregroundColor(.gray)

                Text(hack.estaActivo ? "Activo" : "Inactivo")
                    .font(.footnote)
                    .foregroundColor(hack.estaActivo ? .green : .red)
                    .bold()
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .overlay(
            Divider()
                .padding(.leading)
                .padding(.trailing, 10),
            alignment: .bottom
        )
    }
}

#Preview {
    HackRow(hack: HackPrueba(
        clave: "Hack",
        descripcion: "Descripción del hack",
        equipos: ["Equipo A", "Equipo B"],
        jueces: [],
        rubros: [:],
        estaActivo: true,
        nombre: "Hackathon Ejemplo",
        tiempoPitch: 5.0,
        FechaStart: Date(),
        FechaEnd: Date(),
        valorRubro: 5
    ))
}
