//
//  Hack.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 29/04/24.
//

import Foundation

struct Hack: Identifiable, Hashable {
    let id: UUID
    var nombre: String
    var rubros: [Rubro]
    var tiempoPitch: TimeInterval // Podría ser un Double o un tipo específico para tiempo
    var equipoIDs: [UUID]         // Referencias a los equipos
    var estaActivo: Bool
    var juecesIDs: [UUID]         // Referencias a los jueces
    var rangoPuntuacion: ClosedRange<Int> // Ejemplo: 1...4 o 1...5
}
