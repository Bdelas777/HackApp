//
//  HacksViewModel.swift
//  HackApp
//
//  Created by Alumno on 24/09/24.
//

import Foundation
import FirebaseFirestore

class HacksViewModel: ObservableObject {
    @Published var hacks = [HackPrueba]()
    private var db = Firestore.firestore()
    @Published var isLoading = false
    
    func fetchHacks() {
        isLoading = true
        db.collection("hacks").getDocuments(source: .default) { (querySnapshot, error) in
            if let error = error {
                print("Error al obtener los documentos: \(error)")
                self.hacks = self.defaultHacks()
            } else {
                self.hacks = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    let equipos = data["Equipos"] as? [String] ?? []
                    let jueces = data["Jueces"] as? [String] ?? []
                    let rubrosData = data["Rubros"] as? [String: Any] ?? [:]
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
                    let descripcion = data["descripcion"] as? String ?? ""
                    let fecha = data["fecha"] as? Timestamp ?? Timestamp()
                    let clave = data["clave"] as? String ?? ""
                    
                    let calificaciones = data["calificaciones"] as? [String: [String: [String: Double]]] ?? [:]
                    let finalScores = data["finalScores"] as? [String: Double] ?? [:]

                    return HackPrueba(
                        clave: clave,
                        descripcion: descripcion,
                        equipos: equipos,
                        jueces: jueces,
                        rubros: rubros,
                        estaActivo: estaActivo,
                        nombre: nombre,
                        tiempoPitch: tiempoPitch,
                        Fecha: fecha.dateValue(),
                        calificaciones: calificaciones,
                        finalScores: finalScores
                    )
                } ?? self.defaultHacks()
            }
            self.isLoading = false
        }
    }

    func getJudges(for hackClave: String, completion: @escaping (Result<[String], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
          
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No se encontraron documentos para la clave: \(hackClave)")
                completion(.success([]))
                return
            }
            
            let data = documents.first?.data()
            
            if let jueces = data?["jueces"] as? [String] {
                print(jueces)
                completion(.success(jueces))
            } else {
                completion(.success([]))
            }
        }
    }
    
    func getEquipos(for hackEquipo: String, completion: @escaping (Result<[String], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackEquipo).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
          
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No se encontraron documentos para la clave: \(hackEquipo)")
                completion(.success([]))
                return
            }
            
            let data = documents.first?.data()
            
            if let equipos = data?["equipos"] as? [String] {
                print(equipos)
                completion(.success(equipos))
            } else {
                completion(.success([]))
            }
        }
    }
    
    func saveCalificaciones(for hackClave: String, calificaciones: [String: [String: [String: Double]]?], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "No se encontró el hack para la clave proporcionada."])))
                return
            }

            let existingData = document.data()
            var existingCalificaciones = existingData["calificaciones"] as? [String: [String: [String: Double]]] ?? [:]

            for (equipo, jueces) in calificaciones {
                for (juez, rubros) in jueces ?? [:] {
                    if existingCalificaciones[equipo] == nil {
                        existingCalificaciones[equipo] = [:]
                    }
                    if existingCalificaciones[equipo]?[juez] == nil {
                        existingCalificaciones[equipo]?[juez] = [:]
                    }
                    for (rubro, calificacion) in rubros {
                        existingCalificaciones[equipo]?[juez]?[rubro] = calificacion
                    }
                }
            }

            let documentRef = document.reference
            documentRef.updateData(["calificaciones": existingCalificaciones]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func fetchRubros(for hackClave: String, completion: @escaping (Result<[String: Double], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No se encontraron documentos para la clave: \(hackClave)")
                completion(.success([:]))
                return
            }
            
            let data = documents.first?.data()
            
            if let rubrosData = data?["rubros"] as? [String: Any] {
                let rubros = rubrosData.compactMapValues { value -> Double? in
                    if let doubleValue = value as? Double {
                        return doubleValue
                    } else if let stringValue = value as? String, let convertedValue = Double(stringValue) {
                        return convertedValue
                    }
                    return nil
                }
                completion(.success(rubros))
            } else {
                completion(.success([:]))
            }
        }
    }

    func defaultHacks() -> [HackPrueba] {
        return [
            HackPrueba(
                clave: "HACK1",
                descripcion: "Descripción del Hackathon 1",
                equipos: ["Equipo A", "Equipo B"],
                jueces: ["Juez1", "Juez2"],
                rubros: ["Rubro1": 0.75, "Rubro2": 0.85],
                estaActivo: true,
                nombre: "Hackathon Ejemplo 1",
                tiempoPitch: 5.0,
                Fecha: Date()
            ),
            HackPrueba(
                clave: "HACK2",
                descripcion: "Descripción del Hackathon 2",
                equipos: ["Equipo X", "Equipo Y"],
                jueces: ["Juez3", "Juez4"],
                rubros: ["Rubro3": 0.65, "Rubro4": 0.90],
                estaActivo: false,
                nombre: "Hackathon Ejemplo 2",
                tiempoPitch: 7.0,
                Fecha: Date()
            )
        ]
    }
    
    func getCalificaciones(for teamName: String, hackClave: String, completion: @escaping (Result<[String: [String: Double]], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.success([:])) // No se encontró el hack
                return
            }
            
            let data = document.data()
            
            if let calificaciones = data["calificaciones"] as? [String: [String: [String: Double]]] {
                let teamCalificaciones = calificaciones[teamName] ?? [:]
                completion(.success(teamCalificaciones))
            } else {
                completion(.success([:]))
            }
        }
    }

    func addHack(hack: HackPrueba, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            var hackWithCalificaciones = hack
            hackWithCalificaciones.calificaciones = [:]
            hackWithCalificaciones.finalScores = [:]
            
            let _ = try db.collection("hacks").addDocument(from: hackWithCalificaciones) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getCalificacionesJuez(for teamName: String, judgeName: String, hackClave: String, completion: @escaping (Result<[String: Double]?, Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.success(nil))
                return
            }
            
            let data = document.data()
            
            if let calificaciones = data["calificaciones"] as? [String: [String: [String: Double]]] {
                let teamCalificaciones = calificaciones[teamName]?[judgeName]
                completion(.success(teamCalificaciones))
            } else {
                completion(.success(nil))
            }
        }
    }

    func updateOrSaveCalificaciones(for equipo: String, with finalScore: Double, hackClave: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "No se encontró el hack para la clave proporcionada."])))
                return
            }

            let documentRef = document.reference
            var existingData = document.data()
            var existingCalificaciones = existingData["finalScores"] as? [String: Double] ?? [:]

            // Update the score for the specified team
            existingCalificaciones[equipo] = finalScore

            // Update the document with the new calificaciones structure
            documentRef.updateData(["finalScores": existingCalificaciones]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    func fetchAndCalculateScores(for equipo: String, hackClave: String, completion: @escaping (Result<Double, Error>) -> Void) {
            // Primero, obtenemos las calificaciones
            getCalificaciones(for: equipo, hackClave: hackClave) { result in
                switch result {
                case .success(let calificaciones):
                    // Ahora obtenemos los rubros
                    self.fetchRubros(for: hackClave) { rubrosResult in
                        switch rubrosResult {
                        case .success(let rubros):
                            // Acumulamos la puntuación total
                            let totalScore = self.accumulateScores(calificaciones: calificaciones, rubros: rubros,equipo: equipo, hackClave: hackClave)
                            completion(.success(totalScore))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

    private func accumulateScores(calificaciones: [String: [String: Double]], rubros: [String: Double], equipo: String, hackClave: String) -> Double {
            var totalScore: Double = 0.0
            var totalJudges: Int = 0

            for juez in calificaciones.keys {
                if let rubrosDelJuez = calificaciones[juez] {
                    for rubro in rubrosDelJuez.keys {
                        let calificacion = rubrosDelJuez[rubro] ?? 0.0
                        let pesoRubro = rubros[rubro] ?? 0.0
                        let valorFinal = (calificacion * pesoRubro) / 100.0
                        totalScore += valorFinal
                    }
                    totalJudges += 1
                }
            }
            
            // Guardar el puntaje final
            let finalScore = totalJudges > 0 ? totalScore / Double(totalJudges) : 0.0
            updateOrSaveCalificaciones(for: equipo, with: finalScore, hackClave: hackClave) { _ in }
            
            return finalScore
        }


}
