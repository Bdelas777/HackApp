//
//  FormDataViewModel.swift
//  HackApp
//
//  Created by Alumno on 04/12/24.
//
import Foundation
import SwiftUI

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
