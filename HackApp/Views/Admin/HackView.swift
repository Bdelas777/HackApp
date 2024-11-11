import SwiftUI

// Enum para los tipos de alerta
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

import SwiftUI

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
    @State private var jueces: [String] = [] // Array para los jueces
    @State private var rubros: [String: Double] = [:] // Diccionario para los rubros
    @State private var alertType: AlertType? = nil
    @State private var showEquipos = false
    @State private var showJueces = false
    @State private var showRubros = false
    
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
                infoSection
                statusMessageView
                toggleSectionView(title: "Equipos", isExpanded: $showEquipos, content: equiposView)
                toggleSectionView(title: "Jueces", isExpanded: $showJueces, content: juecesView)
                toggleSectionView(title: "Rubros", isExpanded: $showRubros, content: rubrosView)
                ActionButtons(
                    hack: hack,
                    saveChanges: saveChanges,
                    showCloseAlert: { alertType = .closeHack },
                    showResults: { print("Mostrar Resultados") }
                )
            }
            .padding()
            .navigationTitle("Detalles del Hackathon")
            .onAppear {
                fetchEquipos()
                fetchJudges()  // Llamamos la función para obtener los jueces
                fetchRubros()  // Llamamos la función para obtener los rubros
                checkHackStatus()
            }
            .alert(item: $alertType) { type in
                alert(for: type)
            }
        }
        .background(Color(.systemGroupedBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
    }

    // Sección de información con campos de texto editables
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

    // Vista para mostrar los equipos, jueces y rubros con animación de expansión
    private func toggleSectionView<Content: View>(title: String, isExpanded: Binding<Bool>, content: Content) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .onTapGesture {
                withAnimation {
                    isExpanded.wrappedValue.toggle()
                }
            }
            
            if isExpanded.wrappedValue {
                content
                    .padding(.top, 10)
                    .transition(.opacity)
            }
        }
        .padding(.bottom, 10)
    }

    // Vista para la sección de Equipos
    private var equiposView: some View {
        VStack(alignment: .leading) {
            if let equipos = selectedEquipos, !equipos.isEmpty {
                ForEach(equipos, id: \.self) { equipo in
                    Text(equipo)
                        .font(.subheadline)
                        .padding(.vertical, 5)
                }
            } else {
                Text("No hay equipos asignados.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.leading, 20)
    }

    // Vista para la sección de Jueces
    private var juecesView: some View {
        VStack(alignment: .leading) {
            if !jueces.isEmpty {
                ForEach(jueces, id: \.self) { juez in
                    Text(juez)
                        .font(.subheadline)
                        .padding(.vertical, 5)
                }
            } else {
                Text("No hay jueces asignados.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.leading, 20)
    }

    // Vista para la sección de Rubros
    private var rubrosView: some View {
        VStack(alignment: .leading) {
            if !rubros.isEmpty {
                ForEach(rubros.keys.sorted(), id: \.self) { key in
                    if let value = rubros[key] {
                        HStack {
                            Text(key)
                                .font(.subheadline)
                            Spacer()
                            Text("\(value, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 5)
                    }
                }
            } else {
                Text("No hay rubros definidos.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.leading, 20)
    }

    // Vista de estado del mensaje
    private var statusMessageView: some View {
        Text(viewModel.statusMessage)
            .font(.subheadline)
            .foregroundColor(.orange)
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    // Función para obtener equipos
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

    // Función para obtener los jueces
    private func fetchJudges() {
        viewModel2.getJudges(for: hack.clave) { result in
            switch result {
            case .success(let judges):
                jueces = judges
            case .failure(let error):
                print("Error al obtener jueces: \(error)")
            }
        }
    }

    // Función para obtener los rubros
    private func fetchRubros() {
        viewModel2.fetchRubros(for: hack.clave) { result in
            switch result {
            case .success(let rubrosData):
                rubros = rubrosData
            case .failure(let error):
                print("Error al obtener rubros: \(error)")
            }
        }
    }

    // Función para obtener y calcular puntuaciones
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

    // Función para guardar cambios
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

    // Función para verificar si el hackathon debe cerrarse
    private func checkHackStatus() {
        if hack.estaActivo && hack.FechaEnd < Date() {
            alertType = .closeHack
        }
    }

    // Función para mostrar las alertas
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

    // Función para cerrar el hackathon
    private func closeHack() {
        viewModel.updateHackStatus(hackClave: hack.clave, isActive: false) { success in
            if success {
                alertType = .closeSucess
            } else {
                alertType = .errorProcess
            }
        }
    }
}


#Preview {
    HackView(hack: HackPrueba(
        id: "Ejemplo Hack",
        clave: "Hack",
        descripcion: "Descripción del hack",
        equipos: ["Pedro", "Pablo"],
        jueces: ["Huicho"],
        rubros: ["X": 100],
        estaActivo: true,
        nombre: "Ejemplo",
        tiempoPitch: 29,
        FechaStart: Date(),
        FechaEnd: Date(),
        valorRubro: 5
    ))
}
