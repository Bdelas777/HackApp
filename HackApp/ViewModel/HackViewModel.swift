import Foundation

/// ViewModel para gestionar las operaciones relacionadas con los hackathons.
class HackViewModel: ObservableObject {
    @Published var statusMessage: String = ""
    
    private var viewModel = HacksViewModel()
    
    func updateHack(hack: HackModel, hackClave: String, completion: @escaping (Bool) -> Void) {
        viewModel.updateHack(hack: hack, hackClave: hackClave) { success in
            completion(success)
        }
    }
    
    func updateHackStatus(hackClave: String, isActive: Bool, completion: @escaping (Bool) -> Void) {
        viewModel.updateHackStatus(hackClave: hackClave, isActive: isActive) { success in
            completion(success)
        }
    }
    
    func updateHackStart(hackClave: String, completion: @escaping (Bool) -> Void) {
        viewModel.updateHackStart(hackClave: hackClave) { success in
            completion(success)
        }
    }
    
    func fetchEquipos(clave: String, completion: @escaping (Result<[String], Error>) -> Void) {
        viewModel.getEquipos(for: clave) { result in
            completion(result)
        }
    }
}


