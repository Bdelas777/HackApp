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
    var valoresRubros: [UUID: Double] // Diccionario que asocia un rubro con su valoración
}

extension Evaluacion {
    // Función para añadir una evaluación de rubro
    mutating func evaluar(rubro: Rubro, valor: Double) {
        valoresRubros[rubro.id] = valor
    }
}
