
import Foundation
/// `EquipoViewModel` es un modelo de vista para gestionar la lista de equipos en un hackathon.
/// Permite agregar y eliminar equipos en la lista `equipoList`.
class EquipoViewModel: ObservableObject {
    @Published var equipoList: [Equipo] = []
    
    func agregarEquipo(nombre: String) {
            let nuevoEquipo = Equipo(id: UUID(), nombre: nombre)
            equipoList.append(nuevoEquipo)
        }
        
    
    func eliminarEquipo(_ equipo: Equipo) {
        if let index = equipoList.firstIndex(where: { $0.id == equipo.id }) {
            equipoList.remove(at: index)
        }
    }
}
