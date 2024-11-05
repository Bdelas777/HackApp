import Foundation
import FirebaseFirestore

class HacksViewModel: ObservableObject {
    @Published var hacks = [HackPrueba]()
    private var db = Firestore.firestore()
    @Published var isLoading = false
    @Published var totalScores: [String: Double] = [:]
    @Published var nombre: String = ""
    @Published var isActive: Bool = false
  
    func fetchHackAndEvaluateTeams(for hackClave: String, selectedJudge: String, completion: @escaping (Result<[String: Bool], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "No se encontró el hack para la clave proporcionada."])))
                return
            }

            let data = document.data()

            // Obtener los equipos y las calificaciones
            let equipos = data["equipos"] as? [String] ?? [] // Asegurarse de que se obtienen los equipos correctamente
            let calificaciones = data["calificaciones"] as? [String: [String: [String: Double]]] ?? [:] // Asegurarse de que se obtienen las calificaciones correctamente
            print(calificaciones, "Calificaciones")
            // Crear un diccionario para almacenar si un equipo ha sido calificado por el juez
            var equiposEvaluados = [String: Bool]()
         
            // Recorremos los equipos y verificamos si el juez está presente en las calificaciones
            for equipo in equipos {
                
                if let calificacionesEquipo = calificaciones[equipo], let _ = calificacionesEquipo[selectedJudge] {
                    
                    equiposEvaluados[equipo] = true // El juez ha calificado al equipo
                } else {
                    equiposEvaluados[equipo] = false // El juez no ha calificado al equipo
                }
            }

            print(equiposEvaluados, "Equipos")
            // Devolver el resultado con los equipos y si han sido evaluados o no
            completion(.success(equiposEvaluados))
        }
    }



    func fetchHack(byKey hackClave: String, completion: @escaping (Result<HackPrueba, Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "No se encontró el hack para la clave proporcionada."])))
                return
            }

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
            let fechastart = data["FechaStart"] as? Timestamp ?? Timestamp()
            let fechaend = data["FechaEnd"] as? Timestamp ?? Timestamp()
            let valorrubro = data["valorRubro"] as? Int ?? 0
            let clave = data["clave"] as? String ?? ""
            let calificaciones = data["calificaciones"] as? [String: [String: [String: Double]]] ?? [:]
            let finalScores = data["finalScores"] as? [String: Double] ?? [:]

            let hack = HackPrueba(
                clave: clave,
                descripcion: descripcion,
                equipos: equipos,
                jueces: jueces,
                rubros: rubros,
                estaActivo: estaActivo,
                nombre: nombre,
                tiempoPitch: tiempoPitch,
                FechaStart: fechastart.dateValue(),
                FechaEnd: fechaend.dateValue(),
                valorRubro: valorrubro,
                calificaciones: calificaciones,
                finalScores: finalScores
            )

            completion(.success(hack))
        }
    }

    func fetchHacks() {
        isLoading = true
        db.collection("hacks").getDocuments(source: .default) { (querySnapshot, error) in
            if let error = error {
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
                    let fechastart = data["FechaStart"] as? Timestamp ?? Timestamp()
                    let fechaend = data["FechaEnd"] as? Timestamp ?? Timestamp()
                    let valorrubro = data["valorRubro"] as? Int ?? 0
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
                        FechaStart: fechastart.dateValue(),
                        FechaEnd: fechaend.dateValue(),
                        valorRubro: valorrubro,
                        calificaciones: calificaciones,
                        finalScores: finalScores
                    )
                } ?? self.defaultHacks()
                self.hacks.sort { $0.FechaEnd > $1.FechaEnd }
            }
            self.isLoading = false
        }
    }
    
    /// Elimina un hackathon dado su clave.
    /// - Parameter hackClave: Clave del hackathon a eliminar.
    /// - Parameter completion: Closure que devuelve un resultado de éxito o error.
    func deleteHack(withKey hackClave: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "No se encontró el hack para la clave proporcionada."])))
                return
            }

            // Eliminar el documento
            document.reference.delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }


    /// Obtiene la lista de jueces para un hackathon específico.
    /// - Parameters:
    ///   - hackClave: Clave del hackathon.
    ///   - completion: Closure que devuelve un resultado con la lista de jueces o un error.
    func getJudges(for hackClave: String, completion: @escaping (Result<[String], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
          
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                completion(.success([]))
                return
            }
            
            let data = documents.first?.data()
            
            if let jueces = data?["jueces"] as? [String] {
                completion(.success(jueces))
            } else {
                completion(.success([]))
            }
        }
    }
    
    /// Obtiene la lista de equipos para un hackathon específico.
    /// - Parameters:
    ///   - hackEquipo: Clave del hackathon.
    ///   - completion: Closure que devuelve un resultado con la lista de equipos o un error.
    func getEquipos(for hackEquipo: String, completion: @escaping (Result<[String], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackEquipo).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
          
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                completion(.success([]))
                return
            }
            
            let data = documents.first?.data()
            
            if let equipos = data?["equipos"] as? [String] {
                completion(.success(equipos))
            } else {
                completion(.success([]))
            }
        }
    }
    
    func checkIfKeyExists(_ clave: String, completion: @escaping (Bool) -> Void) {
            db.collection("hacks").whereField("clave", isEqualTo: clave).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    completion(false)
                    return
                }

                let exists = querySnapshot?.documents.count ?? 0 > 0
                completion(exists)
            }
        }
    
    /// Guarda las calificaciones dadas por los jueces para un hackathon específico.
    /// - Parameters:
    ///   - hackClave: Clave del hackathon.
    ///   - calificaciones: Diccionario de calificaciones.
    ///   - completion: Closure que devuelve un resultado de éxito o error.
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
    
    /// Recupera los rubros de evaluación para un hackathon específico.
    /// - Parameters:
    ///   - hackClave: Clave del hackathon.
    ///   - completion: Closure que devuelve un resultado con los rubros o un error.
    func fetchRubros(for hackClave: String, completion: @escaping (Result<[String: Double], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
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

    /// Proporciona un conjunto de hackathons de ejemplo para mostrar en caso de error al recuperar datos.
    /// - Returns: Un array de hackathons de ejemplo.
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
                FechaStart: Date(),
                FechaEnd: Date(),
                valorRubro: 5
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
                FechaStart: Date(),
                FechaEnd: Date(),
                valorRubro: 5
            )
        ]
    }
    
    /// Obtiene las calificaciones para un equipo específico en un hackathon dado.
    /// - Parameters:
    ///   - teamName: Nombre del equipo.
    ///   - hackClave: Clave del hackathon.
    ///   - completion: Closure que devuelve un resultado con las calificaciones o un error.
    func getCalificaciones(for teamName: String, hackClave: String, completion: @escaping (Result<[String: [String: Double]], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.success([:]))
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

    /// Agrega un nuevo hackathon a la colección de Firestore.
    /// - Parameters:
    ///   - hack: El hackathon a agregar.
    ///   - completion: Closure que devuelve un resultado de éxito o error.
    func addHack(hack: HackPrueba, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            var hackWithCalificaciones = hack
            hackWithCalificaciones.calificaciones = [:]
            
            // Crear el diccionario de finalScores con los equipos y su puntaje inicial
            var finalScores: [String: Double] = [:]
            for equipo in hack.equipos {
                finalScores[equipo] = 0.0
            }
            hackWithCalificaciones.finalScores = finalScores

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

    /// Obtiene las calificaciones de un juez para un equipo específico en un hackathon.
    /// - Parameters:
    ///   - teamName: Nombre del equipo.
    ///   - judgeName: Nombre del juez.
    ///   - hackClave: Clave del hackathon.
    ///   - completion: Closure que devuelve un resultado con las calificaciones o un error.
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

    /// Actualiza o guarda las calificaciones finales para un equipo específico en un hackathon.
    /// - Parameters:
    ///   - equipo: Nombre del equipo.
    ///   - finalScore: Puntaje final a actualizar.
    ///   - hackClave: Clave del hackathon.
    ///   - completion: Closure que devuelve un resultado de éxito o error.
    func updateOrSaveCalificaciones(for equipo: String, with finalScore: Double, hackClave: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Solo actualizar si finalScore es mayor que 0
        guard finalScore > 0 else {
            completion(.success(())) // No se realiza ninguna actualización, pero se considera exitoso
            return
        }
        
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
            
            // Actualizar solo el puntaje para el equipo especificado
            documentRef.updateData(["finalScores.\(equipo)": finalScore]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    /// Recupera y calcula el puntaje total para un equipo específico en un hackathon.
    /// - Parameters:
    ///   - equipo: Nombre del equipo.
    ///   - hackClave: Clave del hackathon.
    ///   - completion: Closure que devuelve el puntaje total o un error.
    func fetchAndCalculateScores(for equipo: String, hackClave: String, valorRubro: Int, completion: @escaping (Result<Double, Error>) -> Void) {
        getCalificaciones(for: equipo, hackClave: hackClave) { result in
            switch result {
            case .success(let calificaciones):
                // Ahora obtenemos los rubros
                self.fetchRubros(for: hackClave) { rubrosResult in
                    switch rubrosResult {
                    case .success(let rubros):
                        // Acumulamos la puntuación total
                        let totalScore = self.accumulateScores(calificaciones: calificaciones, rubros: rubros, equipo: equipo, hackClave: hackClave, valorRubro: valorRubro)
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

    /// Acumula las puntuaciones de un equipo a partir de las calificaciones y rubros.
    /// - Parameters:
    ///   - calificaciones: Calificaciones del equipo.
    ///   - rubros: Rubros de evaluación y sus pesos.
    ///   - equipo: Nombre del equipo.
    ///   - hackClave: Clave del hackathon.
    /// - Returns: Puntaje total acumulado.
    private func accumulateScores(calificaciones: [String: [String: Double]], rubros: [String: Double], equipo: String, hackClave: String, valorRubro: Int) -> Double {
        var totalScore: Double = 0.0
        var totalJudges: Int = 0

        for juez in calificaciones.keys {
            if let rubrosDelJuez = calificaciones[juez] {
                for rubro in rubrosDelJuez.keys {
                    let calificacion = rubrosDelJuez[rubro] ?? 0.0
                    let pesoRubro = rubros[rubro] ?? 0.0
                    let valorFinal = (calificacion * pesoRubro) / Double(valorRubro)
                    
                    totalScore += valorFinal
                }
                totalJudges += 1
            }
        }
        
        let finalScore = totalJudges > 0 ? totalScore / Double(totalJudges) : 0.0
        print(finalScore, "Este es el Score final")
        updateOrSaveCalificaciones(for: equipo, with: finalScore, hackClave: hackClave) { _ in }
        
        return finalScore
    }
    
    func updateHack(hack: HackPrueba, hackClave: String, completion: @escaping (Bool) -> Void) {
        let hackData: [String: Any] = [
            "nombre": hack.nombre,
            "descripcion": hack.descripcion,
            "clave": hack.clave,
            "valorRubro": hack.valorRubro,
            "tiempoPitch": hack.tiempoPitch,
            "FechaStart": Timestamp(date: hack.FechaStart),
            "FechaEnd": Timestamp(date: hack.FechaEnd)
        ]
        
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(false)
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                completion(false)
                return
            }

            let documentID = documents[0].documentID
            
            // Actualiza el documento usando su ID
            self.db.collection("hacks").document(documentID).updateData(hackData) { error in
                if let error = error {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }

    func updateHackStatus(hackClave: String, isActive: Bool, completion: @escaping (Bool) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(false)
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                completion(false)
                return
            }
            
            document.reference.updateData(["estaActivo": isActive]) { error in
                if let error = error {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
        
    }
    /// Obtiene el valor del rubro para un hackathon específico.
    /// - Parameters:
    ///   - hackClave: Clave del hackathon.
    ///   - completion: Closure que devuelve un resultado con el valor del rubro o un error.
    func getValorRubro(for hackClave: String, completion: @escaping (Result<Double, Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.success(0.0))
                return
            }
            
            let data = document.data()
            if let valorRubro = data["valorRubro"] as? Int {
                completion(.success(Double(valorRubro)))
            } else {
                completion(.success(0.0))
            }
        }
    }


    /// Obtiene las puntuaciones finales de todos los equipos en un hackathon específico.
    /// - Parameters:
    ///   - hackClave: Clave del hackathon.
    ///   - completion: Closure que devuelve un resultado con las puntuaciones o un error.
    func getScores(for hackClave: String, completion: @escaping (Result<[String: Double], Error>) -> Void) {
        db.collection("hacks").whereField("clave", isEqualTo: hackClave).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents, let document = documents.first else {
                completion(.success([:]))
                return
            }
            
            let data = document.data()
            
            if let finalScores = data["finalScores"] as? [String: Double] {
                completion(.success(finalScores))
            } else {
                completion(.success([:]))
            }
        }
    }
}
