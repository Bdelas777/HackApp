//
//  AddHackForm.swift
//  HackApp
//
//  Created by Alumno on 12/09/24.
//
import SwiftUI

struct AddHackForm: View {
    @Binding var nombre: String
    @Binding var clave: String
    @Binding var descripcion: String
    @Binding var date: Date
    @Binding var dateEnd: Date
    @Binding var valorRubro: String
    @Binding var tiempoPitch: String
    @ObservedObject var listaRubros: RubroViewModel
    @ObservedObject var listaEquipos: EquipoViewModel
    @ObservedObject var listaJueces: JuezViewModel
    @State private var showingAddRubroPopover = false
    @State private var showingAddEquipoPopover = false
    @State private var showingAddJuezPopover = false
    @State private var rubroNombre: String = ""
    @State private var rubroValor: String = ""
    @State private var equipoNombre: String = ""
    @State private var juezNombre: String = ""
    @Binding var showingAlert: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Nombre del Hackathon")) {
                TextField("Nombre del hack", text: $nombre)
            }
            Section(header: Text("Clave del Hackathon")) {
                TextField("Clave del hack", text: $clave)
                    .autocorrectionDisabled(true)
            }
            Section(header: Text("Descripción del Hackathon")) {
                TextField("Descripción del hack", text: $descripcion)
            }
            Section(header: Text("Fecha de inicio del Hackathon")) {
                DatePicker("Selecciona la fecha inicio", selection: $date)
            }
            Section(header: Text("Fecha de fin del Hackathon")) {
                DatePicker("Selecciona la fecha fin", selection: $dateEnd)
            }

            
            Section(header: Text("Duración del pitch (minutos)")) {
                TextField("Valor máximo de los rubros", text: $tiempoPitch)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Valor máximo de los rubros del Hackathon")) {
                TextField("Valor máximo de los rubros", text: $valorRubro)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Rúbrica")) {
                AddRubroButton(showingAddRubroPopover: $showingAddRubroPopover,
                               listaRubros: listaRubros,
                               rubroNombre: $rubroNombre,
                               rubroValor: $rubroValor,
                               showingAlert: $showingAlert)
                
                ForEach(listaRubros.rubroList) { rubro in
                    HStack {
                        Text(rubro.nombre)
                        Spacer()
                        Text("\(rubro.valor, specifier: "%.0f")%")
                    }
                }
            }
            Section(header: Text("Equipos")) {
                AddEquipoButton(showingAddEquipoPopover: $showingAddEquipoPopover,
                                listaEquipos: listaEquipos,
                                equipoNombre: $equipoNombre,
                                showingAlert: $showingAlert)
                
                ForEach(listaEquipos.equipoList) { equipo in
                    HStack {
                        Text(equipo.nombre)
                    }
                }
            }
            Section(header: Text("Jueces")) {
                AddJuezButton(showingAddJuezPopover: $showingAddJuezPopover,
                               listaJueces: listaJueces,
                               juezNombre: $juezNombre,
                               showingAlert: $showingAlert)
                
                ForEach(listaJueces.juezList) { juez in
                    HStack {
                        Text(juez.nombre)
                    }
                }
            }
        }
    }
}
