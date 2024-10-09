//
// LinkDataSource.swift
// HackApp
//
// Created by Alumno on 19/09/24.
//
import Foundation
import FirebaseFirestore

struct HackPrueba: Identifiable, Encodable{
    var id = UUID().uuidString
    var clave: String
    var descripcion: String
    var equipos: [String]
    var jueces: [String]
    var rubros: [String: Double]
    var estaActivo: Bool
    var nombre: String
    var tiempoPitch: Double
    var Fecha: Date
    var calificaciones: [String: [String: [String: Double]]]?
}

