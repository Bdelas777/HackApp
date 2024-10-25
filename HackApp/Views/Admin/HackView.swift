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

    var id: Int {
        switch self {
        case .closeHack: return 1
        case .invalidDate: return 2
        }
    }
}

struct HackView: View {
    var hack: HackPrueba
    @State private var selectedEquipos: [String]?
    @ObservedObject var viewModel = HacksViewModel()
    @State private var alertType: AlertType? = nil
    @State private var nombre: String
    @State private var descripcion: String
    @State private var clave: String
    @State private var valorRubro: Int
    @State private var tiempoPitch: Double
    @State private var fechaStart: Date
    @State private var fechaEnd: Date

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
        VStack {
            VStack(alignment: .leading) {
                // Campos editables
                infoField(title: "Clave:", text: $clave)
                infoField(title: "Nombre:", text: $nombre)
                infoField(title: "Descripción:", text: $descripcion)
                dateField(title: "Fecha Inicio:", date: $fechaStart)
                dateField(title: "Fecha Fin:", date: $fechaEnd)
                infoField(title: "Valor Rubro:", value: $valorRubro)
                infoField(title: "Tiempo Pitch:", value: $tiempoPitch)

                // Botón para guardar cambios
                Button(action: saveChanges) {
                    Text("Guardar Cambios")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(color: Color.green.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .padding(.top)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
            .padding()
            
            Button(action: {
                alertType = .closeHack
            }) {
                Text("Cerrar Hack")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: Color.red.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal)

            Divider()

            NavigationLink(destination: ResultsView(hack: hack)) {
                Text("Ver Resultados")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal)

            VStack {
                Text("Equipos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom)

                List {
                    if let equipos = selectedEquipos, !equipos.isEmpty {
                        ForEach(equipos, id: \.self) { equipo in
                            NavigationLink(destination: TeamView(hack: hack, equipoSeleccionado: equipo)) {
                                Text(equipo)
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                        }
                    } else {
                        Text("No hay equipos disponibles.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .listStyle(PlainListStyle())
            }
            .padding(.bottom)
        }
        .navigationTitle("Detalles del Hackathon")
        .onAppear {
            fetchEquipos()
            checkHackStatus()
        }
        .alert(item: $alertType) { type in
            switch type {
            case .closeHack:
                return Alert(
                    title: Text("Cerrar hack"),
                    message: Text("¿Estás seguro de que quieres cerrar el hack?"),
                    primaryButton: .cancel(),
                    secondaryButton: .default(Text("Confirmar")) {
                        closeHack()
                        fetchEquipos()
                        
                    }
                )
            case .invalidDate:
                return Alert(
                    title: Text("Fecha Invalida"),
                    message: Text("La fecha de inicio no puede ser menor a la fecha de fin."),
                    dismissButton: .default(Text("Aceptar"))
                )
            }
        }
    }

    private func saveChanges() {
        // Validar fechas
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
        
        viewModel.updateHack(hack: updatedHack, hackClave: hack.clave) { success in
            if success {
                print("Hack actualizado exitosamente.")
            } else {
                print("Error al actualizar el hack.")
            }
        }
    }

    private func closeHack() {
        viewModel.updateHackStatus(hackClave: hack.clave, isActive: false) { success in
            if success {
                print("Hack cerrado exitosamente.")
            } else {
                print("Error al cerrar el hack.")
            }
        }
    }

    private func checkHackStatus() {
        print(hack.estaActivo, "Esto es lo que dice")
        if hack.estaActivo && hack.FechaEnd < Date() {
            alertType = .closeHack
        }
    }

    private func infoField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            TextField(title, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
        }
    }
    
    private func infoField(title: String, value: Binding<Int>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            TextField(title, value: value, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
        }
    }

    private func infoField(title: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            TextField(title, value: value, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
        }
    }
    
    private func dateField(title: String, date: Binding<Date>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            DatePicker("", selection: date)
                .labelsHidden()
                .padding(.bottom, 5)
        }
    }

    private func fetchEquipos() {
        viewModel.getEquipos(for: hack.clave) { result in
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
        viewModel.fetchAndCalculateScores(for: equipo, hackClave: hackClave, valorRubro: valorRubro) { result in
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

