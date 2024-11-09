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
        let newJuez = Juez(id: UUID(), nombre: nombre)
        juezList.append(newJuez)
    }
    
    func eliminarJuez(_ juez: Juez) {
           if let index = juezList.firstIndex(where: { $0.id == juez.id }) {
               juezList.remove(at: index)
           }
       }
}
