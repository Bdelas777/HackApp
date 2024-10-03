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

                    return HackPrueba(
                        clave: clave, descripcion: descripcion,
                        equipos: equipos,
                        jueces: jueces,
                        rubros: rubros,
                        estaActivo: estaActivo,
                        nombre: nombre,
                        tiempoPitch: tiempoPitch,
                        Fecha: fecha.dateValue()
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
    
    func saveCalificaciones(for hackClave: String, calificaciones: [String: [String: [Int]]], completion: @escaping (Result<Void, Error>) -> Void) {
        // Fetch the document that matches the hackClave
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "No se encontró el hack para la clave proporcionada."])))
                return
            }

            // Update the document with the new calificaciones structure
            let documentRef = document.reference
            documentRef.updateData([
                "calificaciones": calificaciones
            ]) { error in
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
                completion(.success([:])) // Devuelve un diccionario vacío si no se encuentran rubros
                return
            }
            
            let data = documents.first?.data()
            
            // Extraer los rubros
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
                completion(.success([:])) // Devuelve un diccionario vacío si no se encuentran rubros
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

    func addHackPrueba(hack: HackPrueba, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            var hackWithCalificaciones = hack
            hackWithCalificaciones.calificaciones = [:]
            
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

    
    
}


