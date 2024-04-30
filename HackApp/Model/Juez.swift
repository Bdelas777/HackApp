//
//  Juez.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 29/04/24.
//

import Foundation

struct Juez: Identifiable {
    let id: UUID
    var nombre: String
    var equipoIDs: [UUID] // Referencia a los equipos que evaluará el juez
    var hackID: UUID?     // Referencia opcional al hackathon específico
}
