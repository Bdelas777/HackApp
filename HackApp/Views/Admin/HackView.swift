import SwiftUI

enum AlertType: Identifiable {
    case closeHack, invalidDate, editHack, errorProcess, closeSucess, startSucess, confirmNoShow(equipo: String)

    var id: Int {
        switch self {
        case .closeHack: return 1
        case .invalidDate: return 2
        case .editHack: return 3
        case .errorProcess: return 4
        case .closeSucess: return 5
        case .startSucess: return 6
        case .confirmNoShow: return 7
        }
    }
}

struct HackView: View {
    var hack: HackModel
    @State private var hasChanges = false
    @State private var calificacionesEquipos: [String: Bool] = [:]
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
    @Environment(\.presentationMode) var presentationMode


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
                    showCloseAlert: { alertType = .closeHack },
                    showResults: { print("Mostrar Resultados") },
                    startHack: startHack
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
        .background(Color(.systemGroupedBackground))
    }

    private var infoSection: some View {
            VStack(alignment: .leading, spacing: 20) {
                InfoField(title: "Clave:", text: $clave)
                    .onChange(of: clave) { _ in
                        checkForChanges()
                    }
                    .disabled(hack.estaIniciado)  
                InfoField(title: "Nombre:", text: $nombre)
                    .onChange(of: nombre) { _ in
                        checkForChanges()
                    }
                    .disabled(hack.estaIniciado)  // Deshabilitar si el hack está iniciado

                InfoField(title: "Descripción:", text: $descripcion)
                    .onChange(of: descripcion) { _ in
                        checkForChanges()
                    }
                    .disabled(hack.estaIniciado)  // Deshabilitar si el hack está iniciado

                DateField(title: "Fecha Inicio:", date: $fechaStart)
                    .onChange(of: fechaStart) { _ in
                        checkForChanges()
                    }
                    .disabled(hack.estaIniciado)  // Deshabilitar si el hack está iniciado

                DateField(title: "Fecha Fin:", date: $fechaEnd)
                    .onChange(of: fechaEnd) { _ in
                        checkForChanges()
                    }
                    .disabled(hack.estaIniciado)  // Deshabilitar si el hack está iniciado

                InfoFieldInt(title: "Valor Rubro:", value: $valorRubro)
                    .onChange(of: valorRubro) { _ in
                        checkForChanges()
                    }
                    .disabled(hack.estaIniciado)  // Deshabilitar si el hack está iniciado
                
                InfoFieldDouble(title: "Tiempo Pitch:", value: $tiempoPitch)
                    .onChange(of: tiempoPitch) { _ in
                        checkForChanges()
                    }
                    .disabled(hack.estaIniciado)
        
                if hasChanges && hack.estaIniciado {
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
                    .padding(.top, 20)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 8)
            .padding(.horizontal)
        }

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
    
    private func checkEquipoCalificado(for equipo: String) {
        viewModel2.getCalificaciones(for: equipo, hackClave: hack.clave) { result in
            switch result {
            case .success(let teamCalificaciones):
                DispatchQueue.main.async {
                    calificacionesEquipos[equipo] = !teamCalificaciones.isEmpty
                }
            case .failure:
                DispatchQueue.main.async {
                    calificacionesEquipos[equipo] = false
                }
            }
        }
    }

    
    private var equiposView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let equipos = selectedEquipos, !equipos.isEmpty {
                ForEach(equipos, id: \.self) { equipo in
                    // Usamos un método para verificar si el equipo está calificado
                    HStack {
                        Text(equipo)
                            .font(.body)
                        Spacer()
                        let equipoCalificado = calificacionesEquipos[equipo] ?? false
                        
                        Button(action: {
                            if !equipoCalificado {
                                alertType = .confirmNoShow(equipo: equipo)
                            }
                        }) {
                            Text("No se presentó")
                                .font(.body)
                                .foregroundColor(equipoCalificado ? .gray : .white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(equipoCalificado ? Color.gray : Color.red)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.leading)
                        .disabled(equipoCalificado)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom, 8)
                    // Llamamos al método para verificar las calificaciones cuando la vista aparece
                    .onAppear {
                        checkEquipoCalificado(for: equipo)
                    }
                }
            } else {
                Text("No hay equipos asignados.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }



    private var juecesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !jueces.isEmpty {
                ForEach(jueces, id: \.self) { juez in
                    HStack {
                        Text(juez)
                            .font(.body)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom, 8)
                }
            } else {
                Text("No hay jueces asignados.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading) // Alineación y ocupación del espacio
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }

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
            finalScores: hack.finalScores,
            estaIniciado: hack.estaIniciado
        )
        
        viewModel.updateHack(hack: updatedHack) { success in
            if success {
                alertType = .editHack
                presentationMode.wrappedValue.dismiss()

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
        case .startSucess:
            return Alert(
                title: Text("Hack iniciado"),
                message: Text("El hack se ha iniciado exitosamente"),
                dismissButton: .default(Text("Aceptar"))
            )
        case .confirmNoShow(let equipo):
            return Alert(
                title: Text("Confirmar No Presentación"),
                message: Text("¿Estás seguro de que \(equipo) no se presentó? Todos los jueces calificarán este equipo con 0."),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Confirmar")) {
                    markNoShowForTeam(hackClave: hack.clave, equipo: equipo)
                }
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
    
    private func markNoShowForTeam(hackClave: String, equipo: String) {
        viewModel2.saveCalificacionesForAllJudges(for: hackClave, equipo: equipo, calificacion: 0) { result in
            switch result {
            case .success:
                print("Las calificaciones de \(equipo) han sido actualizadas a 0 para todos los jueces.")
            case .failure(let error):
                print("Error al actualizar las calificaciones: \(error)")
            }
        }
    }

    private func startHack() {
        viewModel.updateHackStart(hackClave: hack.clave) { success in
            if success {
                alertType = .startSucess
            } else {
                alertType = .errorProcess
            }
        }
    }
    
    private func checkForChanges() {
        hasChanges = (nombre != hack.nombre ||
                      descripcion != hack.descripcion ||
                      clave != hack.clave ||
                      valorRubro != hack.valorRubro ||
                      tiempoPitch != hack.tiempoPitch ||
                      fechaStart != hack.FechaStart ||
                      fechaEnd != hack.FechaEnd)
    }

}
