
import Foundation

/// ViewModel encargado de gestionar la lista de rubros en el sistema.

class RubroViewModel: ObservableObject {
    @Published var rubroList: [Rubro] = []
    func addRubro(nombre: String, valor: Double) {
            let nuevoRubro = Rubro(nombre: nombre, valor: valor)
            rubroList.append(nuevoRubro)
        }

    func eliminarRubro(_ rubro: Rubro) {
        if let index = rubroList.firstIndex(where: { $0.id == rubro.id }) {
            rubroList.remove(at: index)
        }
    }
}
