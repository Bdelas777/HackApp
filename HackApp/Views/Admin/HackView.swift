import SwiftUI

enum AlertType: Identifiable {
    case closeHack, invalidDate, editHack, errorProcess, closeSucess

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
/// Vista para gestionar los detalles de un Hackathon.
///
/// Esta vista permite editar los detalles de un hackathon, ver equipos, jueces y rubros, y actualizar el estado del hackathon.
/// También muestra alertas para confirmar acciones como cerrar el hackathon o gestionar errores.
///
/// **Propiedades**:
/// - `hack`: Información del hackathon.
/// - `nombre`, `descripcion`, `clave`: Campos editables del hackathon.
/// - `valorRubro`, `tiempoPitch`, `fechaStart`, `fechaEnd`: Atributos del hackathon.
/// - `selectedEquipos`, `jueces`, `rubros`: Datos relacionados con equipos, jueces y rubros.
/// - `alertType`: Tipo de alerta a mostrar.
/// - `showEquipos`, `showJueces`, `showRubros`: Estados para mostrar las secciones correspondientes.

struct HackView: View {
    var hack: HackModel
    @State private var nombre: String
    @State private var descripcion: String
    @State private var clave: String
    @State private var valorRubro: Int
    @State private var tiempoPitch: Double
    @State private var fechaStart: Date
    @State private var fechaEnd: Date
    @State private var selectedEquipos: [String]?
    @State private var jueces: [String] = []
    @State private var rubros: [String: Double] = [:]
    @State private var alertType: AlertType? = nil
    @State private var showEquipos = false
    @State private var showJueces = false
    @State private var showRubros = false
    @ObservedObject var viewModel = HackViewModel()
    @ObservedObject var viewModel2 = HacksViewModel()

    init(hack: HackModel) {
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
                toggleSectionView(title: "Criterios", isExpanded: $showRubros, content: rubrosView)
                ActionButtons(
                    hack: hack,
                    saveChanges: saveChanges,
                    showCloseAlert: { alertType = .closeHack },
                    showResults: { print("Mostrar Resultados") }
                )
            }
            .padding()
            .cornerRadius(20)
            .shadow(radius: 15)
            .navigationTitle("Detalles del Hackathon")
            .onAppear {
                fetchEquipos()
                fetchJudges()
                fetchRubros()
                checkHackStatus()
            }
            .alert(item: $alertType) { type in
                alert(for: type)
            }
        }
        .background(Color(.systemGroupedBackground)) // Fondo más claro
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            
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
        .cornerRadius(16)
        .shadow(radius: 8)
        .padding(.horizontal)
    }

    // Sección para expandir y colapsar las vistas internas (Equipos, Jueces, Rubros)
    private func toggleSectionView<Content: View>(title: String, isExpanded: Binding<Bool>, content: Content) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(12)
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
    }

    private var equiposView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let equipos = selectedEquipos, !equipos.isEmpty {
                ForEach(equipos, id: \.self) { equipo in
                    Text(equipo)
                        .font(.body)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.15), radius: 5, x: 0, y: 3)
                        .padding(.bottom, 8)
                }
            } else {
                Text("No hay equipos asignados.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }

    // Vista de Jueces
    private var juecesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !jueces.isEmpty {
                ForEach(jueces, id: \.self) { juez in
                    Text(juez)
                        .font(.body)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.15), radius: 5, x: 0, y: 3)
                        .padding(.bottom, 8)
                }
            } else {
                Text("No hay jueces asignados.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }

    // Vista de Rubros
    private var rubrosView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !rubros.isEmpty {
                ForEach(rubros.keys.sorted(), id: \.self) { key in
                    if let value = rubros[key] {
                        HStack {
                            Text(key)
                                .font(.body)
                            Spacer()
                            Text("\(value, specifier: "%.2f")")
                                .font(.body)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.15), radius: 5, x: 0, y: 3)
                        .padding(.bottom, 8)
                    }
                }
            } else {
                Text("No hay rubros definidos.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }

    // Mensaje de estado
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

    private func saveChanges() {
        if fechaStart >= fechaEnd {
            alertType = .invalidDate
            return
        }
        
        let updatedHack = HackModel(
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
