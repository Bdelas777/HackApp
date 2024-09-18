//
//  JuezViewModel.swift
//  HackApp
//
//  Created by Alumno on 18/09/24.
//


import Foundation
import Combine

class JuezViewModel: ObservableObject {
    @Published var juezList: [Juez] = []
    
    func addJuez(nombre: String, equipoIDs: [UUID]) {
        let newJuez = Juez(id: UUID(), nombre: nombre, equipoIDs: equipoIDs, hackID: nil)
        juezList.append(newJuez)
    }
}
