
import Foundation
/// `EquipoViewModel` gestiona la lista de equipos en un Hackathon.
///
/// **Propiedades**:
/// - `equipoList`: Lista de equipos.
///
/// **Métodos**:
/// - `eliminarEquipo(_:)`: Elimina un equipo de la lista mediante su ID.
class EquipoViewModel: ObservableObject {
    @Published var equipoList: [Equipo] = []
    func eliminarEquipo(_ equipo: Equipo) {
        if let index = equipoList.firstIndex(where: { $0.id == equipo.id }) {
            equipoList.remove(at: index)
        }
    }
}
