//
//  Equipo.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 29/04/24.
//

import Foundation

struct Equipo: Identifiable {
    let id: UUID
    var nombre: String
}





//// Crear un rubro
//let rubro = Rubro(id: UUID(), nombre: "Creatividad", valor: 10.0)
//
//// Crear un hackathon
//var hackathon = Hack(id: UUID(),
//                     nombre: "Hack Innovación",
//                     rubros: [rubro],
//                     tiempoPitch: 180, // 3 minutos en segundos
//                     equipoIDs: [],
//                     estaActivo: true,
//                     juecesIDs: [],
//                     rangoPuntuacion: 1...5)
//
//// Crear un juez
//let juez = Juez(id: UUID(), nombre: "Ana Pérez", equipoIDs: [], hackID: hackathon.id)
//
//// Añadir el juez al hackathon
//hackathon.juecesIDs.append(juez.id)
//
//// Crear una evaluación
//var evaluacion = Evaluacion(id: UUID(),
//                            idEquipo: UUID(),
//                            idJuez: juez.id,
//                            valoresRubros: [:])
//
//// Evaluar un rubro
//evaluacion.evaluar(rubro: rubro, valor: 8.5)
