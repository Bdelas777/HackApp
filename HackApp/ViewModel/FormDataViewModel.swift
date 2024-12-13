import Foundation
import SwiftUI

/// `FormDataViewModel` es un modelo de vista que gestiona los datos del formulario para crear o editar un hackathon.
/// Esta clase contiene los valores de los campos que se ingresan en el formulario, como el nombre, la clave, la descripción, las fechas, el valor de los rubros, el tiempo del pitch, y las listas de equipos, jueces y rubros.
class FormDataViewModel: ObservableObject {
    @Published var nombre: String = ""
    @Published var clave: String = ""
    @Published var descripcion: String = ""
    @Published var date: Date = Date()
    @Published var dateEnd: Date = Date()
    @Published var valorRubro: String = ""
    @Published var tiempoPitch: String = ""
    
    @ObservedObject var listaRubros: RubroViewModel
    @ObservedObject var listaEquipos: EquipoViewModel
    @ObservedObject var listaJueces: JuezViewModel
    
    init(listaRubros: RubroViewModel, listaEquipos: EquipoViewModel, listaJueces: JuezViewModel) {
        self.listaRubros = listaRubros
        self.listaEquipos = listaEquipos
        self.listaJueces = listaJueces
    }
    
    // Reset all data
    func resetForm() {
        self.nombre = ""
        self.clave = ""
        self.descripcion = ""
        self.date = Date()
        self.dateEnd = Date()
        self.valorRubro = ""
        self.tiempoPitch = ""
        
        listaEquipos.equipoList.removeAll()
        listaJueces.juezList.removeAll()
        listaRubros.rubroList.removeAll()
    }
}
