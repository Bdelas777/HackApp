//
//  Hack.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 29/04/24.
//

import Foundation
import SwiftData

@Model
class Hack: Hashable, ObservableObject, Identifiable, Codable {
    var id: UUID
    var nombre: String
    var rubros: [Rubro] = []
    var tiempoPitch: Double
    var equipoIDs: [UUID]
    var estaActivo: Bool
    var juecesIDs: [UUID]
    var rangoPuntuacion: ClosedRange<Int>
    
    enum CodingKeys: String, CodingKey {
        case id, nombre, rubros, tiempoPitch, equipoIDs, estaActivo, juecesIDs, rangoPuntuacion
    }
    
    required init() {
        self.id = UUID()
        self.nombre = ""
        self.tiempoPitch = 0.0
        self.equipoIDs = []
        self.estaActivo = false
        self.juecesIDs = []
        self.rangoPuntuacion = 1...5
    }
    
    init(nombre: String, rubros: [Rubro] = [], tiempoPitch: Double, equipoIDs: [UUID], estaActivo: Bool, juecesIDs: [UUID], rangoPuntuacion: ClosedRange<Int>) {
        self.id = UUID()
        self.nombre = nombre
        self.rubros = rubros
        self.tiempoPitch = tiempoPitch
        self.equipoIDs = equipoIDs
        self.estaActivo = estaActivo
        self.juecesIDs = juecesIDs
        self.rangoPuntuacion = rangoPuntuacion
    }
    
    // Equatable conformance
    static func == (lhs: Hack, rhs: Hack) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.nombre = try container.decode(String.self, forKey: .nombre)
        self.rubros = try container.decode([Rubro].self, forKey: .rubros)
        self.tiempoPitch = try container.decode(Double.self, forKey: .tiempoPitch)
        self.equipoIDs = try container.decode([UUID].self, forKey: .equipoIDs)
        self.estaActivo = try container.decode(Bool.self, forKey: .estaActivo)
        self.juecesIDs = try container.decode([UUID].self, forKey: .juecesIDs)
        self.rangoPuntuacion = try container.decode(ClosedRange<Int>.self, forKey: .rangoPuntuacion)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(nombre, forKey: .nombre)
        try container.encode(rubros, forKey: .rubros)
        try container.encode(tiempoPitch, forKey: .tiempoPitch)
        try container.encode(equipoIDs, forKey: .equipoIDs)
        try container.encode(estaActivo, forKey: .estaActivo)
        try container.encode(juecesIDs, forKey: .juecesIDs)
        try container.encode(rangoPuntuacion, forKey: .rangoPuntuacion)
    }
    
    // Additional methods based on the specific logic needed for `Hack` can be added here.
    // Example method:
    func activateHack() {
        self.estaActivo = true
    }
    
    func deactivateHack() {
        self.estaActivo = false
    }
    
    func updateRubro(at index: Int, with newRubro: Rubro) -> [Rubro] {
        guard index >= 0 && index < self.rubros.count else {
            print("Invalid index \(index).")
            return self.rubros
        }
        self.rubros[index] = newRubro
        return self.rubros
    }
}
