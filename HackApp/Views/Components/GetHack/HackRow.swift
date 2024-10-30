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
    @EnvironmentObject var viewModel: HacksViewModel


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
                        .font(.title3)
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.1), in: Circle())
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
            .background(hack.estaActivo ? Color.white : Color.gray.opacity(0.3)) // Fondo gris para hacks inactivos
            .cornerRadius(8)
            .shadow(radius: 3)
            .frame(height: 200) // Establecer una altura fija para el HackRow
        }
        .padding(.vertical, 5)
        .overlay(
            Divider()
                .padding(.leading)
                .padding(.trailing, 10),
            alignment: .bottom
        )
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
