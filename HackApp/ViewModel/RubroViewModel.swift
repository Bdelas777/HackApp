//
//  RubroViewModel.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 30/05/24.
//

import Foundation

class RubroViewModel: ObservableObject {
    @Published var rubroList: [Rubro] = []
    
    // Método para eliminar rubro
    func eliminarRubro(_ rubro: Rubro) {
        if let index = rubroList.firstIndex(where: { $0.id == rubro.id }) {
            rubroList.remove(at: index)
        }
    }
}
