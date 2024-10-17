// LinkDataSource.swift
// HackApp
//
// Created by Alumno on 19/09/24.
//

import Foundation
import FirebaseFirestore

/// Estructura que representa un hackathon.
/// Esta estructura se utiliza para almacenar y manejar la información relevante sobre un hackathon específico.
struct HackPrueba: Identifiable, Encodable {
    /// Identificador único del hackathon.
    var id = UUID().uuidString
    
    /// Clave única que identifica el hackathon.
    var clave: String
    
    /// Descripción del hackathon.
    var descripcion: String
    
    /// Lista de equipos que participan en el hackathon.
    var equipos: [String]
    
    /// Lista de jueces asignados al hackathon.
    var jueces: [String]
    
    /// Diccionario que contiene los rubros de evaluación y sus puntajes asociados.
    var rubros: [String: Double]
    
    /// Indica si el hackathon está activo (true) o inactivo (false).
    var estaActivo: Bool
    
    /// Nombre del hackathon.
    var nombre: String
    
    /// Tiempo asignado para la presentación del proyecto en minutos.
    var tiempoPitch: Double
    
    /// Fecha en la que se lleva a cabo el hackathon.
    var Fecha: Date
    
    /// Diccionario que almacena las calificaciones dadas por los jueces a los equipos.
    /// La estructura es: [equipo: [juez: [rubros: puntaje]]]
    var calificaciones: [String: [String: [String: Double]]]?
    
    /// Diccionario que almacena las puntuaciones finales de cada equipo.
    /// La estructura es: [equipo: puntuación final]
    var finalScores: [String: Double]?
}
