// LinkDataSource.swift
// HackApp
//
// Created by Alumno on 19/09/24.
//

import Foundation
import FirebaseFirestore

/// Estructura que representa un hackathon.
/// Esta estructura se utiliza para almacenar y manejar la información relevante sobre un hackathon específico.
struct HackModel: Identifiable, Encodable {
    var id = UUID().uuidString
    var clave: String
    var descripcion: String
    var equipos: [String]
    var jueces: [String]
    var rubros: [String: Double]
    var estaActivo: Bool
    var nombre: String
    var tiempoPitch: Double
    var FechaStart: Date
    var FechaEnd: Date
    var valorRubro: Int
    var calificaciones: [String: [String: [String: Double]]]?
    var finalScores: [String: Double]?
    var notas: [String: [String: String]]?
    var estaIniciado: Bool
}
