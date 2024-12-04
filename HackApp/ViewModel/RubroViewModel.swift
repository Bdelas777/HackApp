//
//  RubroViewModel.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 30/05/24.
//

import Foundation

/// ViewModel para gestionar las operaciones de rubros en la aplicación.
class RubroViewModel: ObservableObject {
    @Published var rubroList: [Rubro] = []

    func eliminarRubro(_ rubro: Rubro) {
        if let index = rubroList.firstIndex(where: { $0.id == rubro.id }) {
            rubroList.remove(at: index)
        }
    }
}
