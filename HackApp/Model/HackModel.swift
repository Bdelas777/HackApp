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
    
    /// Indica si el hackathon está activo (true) o inactivo (false).
    var estaActivo: Bool
    
    /// Nombre del hackathon.
    var nombre: String
    
    /// Tiempo asignado para la presentación del proyecto en minutos.
    var tiempoPitch: Double
    
    /// Fecha   de inicio en la que se lleva a cabo el hackathon.
    var FechaStart: Date
    var FechaEnd: Date
    var valorRubro: Int
    var calificaciones: [String: [String: [String: Double]]]?
    var finalScores: [String: Double]?
}
