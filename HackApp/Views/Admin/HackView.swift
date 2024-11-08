//
//  HackView.swift
//  HackApp
//
//  Created by Alumno on 24/09/24.
//
import SwiftUI

enum AlertType: Identifiable {
    case closeHack
    case invalidDate
    case editHack
    case errorProcess
    case closeSucess
    
    var id: Int {
        switch self {
        case .closeHack: return 1
        case .invalidDate: return 2
        case .editHack: return 3
        case .errorProcess: return 4
        case .closeSucess: return 5
        }
    }
}

struct HackView: View {
    var hack: HackPrueba
    @State private var nombre: String
    @State private var descripcion: String
    @State private var clave: String
    @State private var valorRubro: Int
    @State private var tiempoPitch: Double
    @State private var fechaStart: Date
    @State private var fechaEnd: Date
    @State private var selectedEquipos: [String]?
    @State private var alertType: AlertType? = nil
    
    @ObservedObject var viewModel = HackViewModel()
    @ObservedObject var viewModel2 = HacksViewModel()
    init(hack: HackPrueba) {
        self.hack = hack
        _nombre = State(initialValue: hack.nombre)
        _descripcion = State(initialValue: hack.descripcion)
        _clave = State(initialValue: hack.clave)
        _valorRubro = State(initialValue: hack.valorRubro)
        _tiempoPitch = State(initialValue: hack.tiempoPitch)
        _fechaStart = State(initialValue: hack.FechaStart)
        _fechaEnd = State(initialValue: hack.FechaEnd)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Sección de Información
                infoSection
                
                // Mensaje de estado
                statusMessageView
                
                // Botones de acción
                ActionButtons(
                    hack: hack,
                    saveChanges: saveChanges,
                    showCloseAlert: { alertType = .closeHack },
                    showResults: { print("Show Results") }
                )
            }
            .padding()
            .navigationTitle("Detalles del Hackathon")
            .onAppear {
                fetchEquipos()
                checkHackStatus()
            }
            .alert(item: $alertType) { type in
                alert(for: type)
            }
        }
    }
    
    private func saveChanges() {
        if fechaStart >= fechaEnd {
            alertType = .invalidDate
            return
        }
        
        let updatedHack = HackPrueba(
            clave: clave,
            descripcion: descripcion,
            equipos: hack.equipos,
            jueces: hack.jueces,
            rubros: hack.rubros,
            estaActivo: hack.estaActivo,
            nombre: nombre,
            tiempoPitch: tiempoPitch,
            FechaStart: fechaStart,
            FechaEnd: fechaEnd,
            valorRubro: valorRubro,
            calificaciones: hack.calificaciones,
            finalScores: hack.finalScores
        )
        
        viewModel.updateHack(hack: updatedHack) { success in
            if success {
                alertType = .editHack
            } else {
                alertType = .errorProcess
            }
        }
    }
    
    private func closeHack() {
        viewModel.updateHackStatus(hackClave: hack.clave, isActive: false) { success in
            if success {
                alertType = .closeSucess
            } else {
                alertType = .errorProcess
            }
        }
    }
    
    private func checkHackStatus() {
        if hack.estaActivo && hack.FechaEnd < Date() {
            alertType = .closeHack
        }
    }
    
    private func alert(for type: AlertType) -> Alert {
        switch type {
        case .closeHack:
            return Alert(
                title: Text("Cerrar hack"),
                message: Text("¿Estás seguro de que quieres cerrar el hack?"),
                primaryButton: .cancel(),
                secondaryButton: .default(Text("Confirmar")) {
                    closeHack()
                }
            )
        case .invalidDate:
            return Alert(
                title: Text("Fecha Invalida"),
                message: Text("La fecha de inicio no puede ser menor a la fecha de fin."),
                dismissButton: .default(Text("Aceptar"))
            )
        case .editHack:
            return Alert(
                title: Text("Se ha editado"),
                message: Text("Los datos del Hack se han actualizado con éxito"),
                dismissButton: .default(Text("Aceptar"))
            )
        case .errorProcess:
            return Alert(
                title: Text("Error"),
                message: Text("Se ha producido un error"),
                dismissButton: .default(Text("Aceptar"))
            )
        case .closeSucess:
            return Alert(
                title: Text("Cerrar hack"),
                message: Text("El hack se ha cerrado exitosamente"),
                dismissButton: .default(Text("Aceptar"))
            )
        }
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Información del Hackathon")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            InfoField(title: "Clave:", text: $clave)
            InfoField(title: "Nombre:", text: $nombre)
            InfoField(title: "Descripción:", text: $descripcion)
            DateField(title: "Fecha Inicio:", date: $fechaStart)
            DateField(title: "Fecha Fin:", date: $fechaEnd)
            InfoFieldInt(title: "Valor Rubro:", value: $valorRubro)
            InfoFieldDouble(title: "Tiempo Pitch:", value: $tiempoPitch)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
    
    private var statusMessageView: some View {
        Text(viewModel.statusMessage)
            .font(.subheadline)
            .foregroundColor(.orange)
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func fetchEquipos() {
        viewModel.fetchEquipos(clave: hack.clave) { result in
            switch result {
            case .success(let equipos):
                selectedEquipos = equipos.isEmpty ? nil : equipos
                if let equipos = selectedEquipos {
                                   for equipo in equipos {
                                       fetchAndCalculateScores(for: equipo, hackClave: hack.clave, valorRubro: hack.valorRubro)
                                   }
                               }

            case .failure:
                selectedEquipos = nil
            }
        }
    }
    
    private func fetchAndCalculateScores(for equipo: String, hackClave: String, valorRubro: Int) {
        viewModel2.fetchAndCalculateScores(for: equipo, hackClave: hackClave, valorRubro: valorRubro) { result in
               switch result {
               case .success(let totalScore):
                   print("Puntuación total para \(equipo): \(totalScore)")
               case .failure(let error):
                   print("Error al calcular la puntuación: \(error)")
               }
           }
       }

    
}

#Preview {
    HackView(hack: HackPrueba(
        id: "Ejemplo Hack",
        clave: "Hack",
        descripcion: "Descripción del hack",
        equipos: [],
        jueces: [],
        rubros: [:],
        estaActivo: true,
        nombre: "Ejemplo",
        tiempoPitch: 29,
        FechaStart: Date(),
        FechaEnd: Date(),
        valorRubro: 5
    ))
}
