//
//  Evaluacion.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 29/04/24.
//

import Foundation

struct Evaluacion: Identifiable {
    let id: UUID
    var idEquipo: UUID
    var idJuez: UUID
    var valoresRubros: [UUID: Double] 
}

