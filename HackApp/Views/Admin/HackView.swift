//
//  HackView.swift
//  HackApp
//
//  Created by Alumno on 24/09/24.
//

import SwiftUI

struct HackView: View {
    var hack: HackPrueba

    var body: some View {
        VStack {
            Text(hack.nombre)
                .font(.largeTitle)
                .padding()

            Text(hack.descripcion)
                .font(.body)
                .padding()

            Text("Fecha: \(hack.Fecha, style: .date)")
                .padding()

            Text(hack.estaActivo ? "Estado: Activo" : "Estado: Inactivo")
                .foregroundColor(hack.estaActivo ? .green : .red)
                .padding()
        }
        .navigationTitle("Detalles del Hackathon")
    }
}

#Preview {
    HackView(hack: HackPrueba(id: "Ejemplo Hack", descripcion: "Descripción del hack",   equipos: [], jueces: [:], rubros: [:], estaActivo: true, nombre: "Ejemplo", tiempoPitch: 29, Fecha: Date()))
}
