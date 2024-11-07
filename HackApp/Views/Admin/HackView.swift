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
    @State private var statusMessage: String = ""
    
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
                actionButtons
            }
            .padding()
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
        }
    }

    // Sección de información de formulario
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Información del Hackathon")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            infoField(title: "Clave:", text: $clave)
            infoField(title: "Nombre:", text: $nombre)
            infoField(title: "Descripción:", text: $descripcion)
            dateField(title: "Fecha Inicio:", date: $fechaStart)
            dateField(title: "Fecha Fin:", date: $fechaEnd)
            infoField(title: "Valor Rubro:", value: $valorRubro)
            infoField(title: "Tiempo Pitch:", value: $tiempoPitch)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }

    // Mensaje de estado
    private var statusMessageView: some View {
        Text(statusMessage)
            .font(.subheadline)
            .foregroundColor(.orange)
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    // Botones de acción
    private var actionButtons: some View {
        VStack(spacing: 15) {
            saveButton
            navigationLinkButton
            closeHackButton
        }
        .padding(.top, 20)
    }
    
    private var saveButton: some View {
        Button(action: saveChanges) {
            Text("Guardar Cambios")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(hack.estaActivo ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.green.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .disabled(!hack.estaActivo)
    }

    private var navigationLinkButton: some View {
        NavigationLink(destination: ResultsView(hack: hack)) {
            Text("Ver Resultados")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
    }

    private var closeHackButton: some View {
        HStack {
            Spacer()
            Button(action: {
                alertType = .closeHack
            }) {
                Text("Cerrar Hack")
                    .font(.headline)
                    .padding()
                    .frame(width: 130)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.red.opacity(0.3), radius: 2, x: 0, y: 2)
            }
            .padding(.trailing, 20) // Espaciado al lado derecho
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

    private func infoField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            TextField(title, text: text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }

    private func infoField(title: String, value: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            TextField(title, value: value, formatter: NumberFormatter())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }

    private func infoField(title: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            TextField(title, value: value, formatter: NumberFormatter())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }

    private func dateField(title: String, date: Binding<Date>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            DatePicker("", selection: date, displayedComponents: .date)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }

    private func fetchEquipos() {
        viewModel.getEquipos(for: hack.clave) { result in
            switch result {
            case .success(let equipos):
                selectedEquipos = equipos.isEmpty ? nil : equipos
            case .failure:
                selectedEquipos = nil
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
