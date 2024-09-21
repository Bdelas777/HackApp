//
// LinkDataSource.swift
// HackApp
//
// Created by Alumno on 19/09/24.
//
import Foundation
import FirebaseFirestore

struct HackPrueba: Identifiable {
    var id = UUID().uuidString
    var equipos: [String]
    var jueces: [String: [String: Int]?]
    var rubros: [String: Double]
    var estaActivo: Bool
    var nombre: String
    var tiempoPitch: Double
}

class HacksViewModel: ObservableObject {
    @Published var hacks = [HackPrueba]()
    private var db = Firestore.firestore()
    
    func fetchHacks() {
        db.collection("hacks").getDocuments(source: .default) { (querySnapshot, error) in
            if let error = error {
                print("Error al obtener los documentos: \(error)")
                
                // Datos por defecto en caso de error
                self.hacks = self.defaultHacks()
                
            } else {
                self.hacks = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    print(data)
                    
                    let equipos = data["Equipos"] as? [String] ?? []
                    
                    // Manejo seguro de jueces
                    let jueces = data["Juez"] as? [String: [String: Int]?] ?? [:]
                    
                    // Conversión de rubros de String a Double cuando sea necesario
                    let rubrosData = data["Rubro"] as? [String: Any] ?? [:]
                    let rubros = rubrosData.compactMapValues { value -> Double? in
                        if let doubleValue = value as? Double {
                            return doubleValue
                        } else if let stringValue = value as? String, let convertedValue = Double(stringValue) {
                            return convertedValue
                        }
                        return nil
                    }
                    
                    let estaActivo = data["estaActivo"] as? Bool ?? false
                    let nombre = data["nombre"] as? String ?? ""
                    let tiempoPitch = data["tiempoPitch"] as? Double ?? 0.0
                    
                    return HackPrueba(equipos: equipos, jueces: jueces, rubros: rubros, estaActivo: estaActivo, nombre: nombre, tiempoPitch: tiempoPitch)
                    
                } ?? self.defaultHacks()  // Si no hay documentos, usar datos por defecto
            }
        }
    }
    
    // Función para generar datos por defecto
    func defaultHacks() -> [HackPrueba] {
        return [
            HackPrueba(
                equipos: ["Equipo A", "Equipo B"],
                jueces: ["Juez1": ["Criterio1": 8, "Criterio2": 7], "Juez2": ["Criterio1": 9, "Criterio2": 8]],
                rubros: ["Rubro1": 0.75, "Rubro2": 0.85],
                estaActivo: true,
                nombre: "Hackathon Ejemplo 1",
                tiempoPitch: 5.0
            ),
            HackPrueba(
                equipos: ["Equipo X", "Equipo Y"],
                jueces: ["Juez3": ["Criterio1": 6, "Criterio2": 7], "Juez4": ["Criterio1": 8, "Criterio2": 9]],
                rubros: ["Rubro3": 0.65, "Rubro4": 0.90],
                estaActivo: false,
                nombre: "Hackathon Ejemplo 2",
                tiempoPitch: 7.0
            )
        ]
    }
}

