//
//  EquipoViewModel.swift
//  HackApp
//
//  Created by Alumno on 13/09/24.
//

import Foundation


class EquipoViewModel: ObservableObject {
    @Published var equipoList: [Equipo] = []
    
    // Método para eliminar un equipo
    func eliminarEquipo(_ equipo: Equipo) {
        if let index = equipoList.firstIndex(where: { $0.id == equipo.id }) {
            equipoList.remove(at: index)
        }
    }
}
