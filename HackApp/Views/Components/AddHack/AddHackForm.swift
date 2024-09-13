//
//  AddHackForm.swift
//  HackApp
//
//  Created by Alumno on 12/09/24.
//

import SwiftUI

struct AddHackForm: View {
    @Binding var nombre: String
    @Binding var descripcion: String
    @Binding var numJueces: Int
    @Binding var date: Date
    @Binding var tiempoPitch: Double
    @ObservedObject var listaRubros: RubroViewModel
    @ObservedObject var listaEquipos: EquipoViewModel // Añade esta propiedad
    @State private var showingAddRubroPopover = false
    @State private var showingAddEquipoPopover = false // Añade esta propiedad
    @State private var rubroNombre: String = ""
    @State private var rubroValor: String = ""
    @State private var equipoNombre: String = "" // Añade esta propiedad
    @Binding var showingAlert: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Nombre del Hackathon")) {
                TextField("Nombre del hack", text: $nombre)
            }
            Section(header: Text("Descripción del Hackathon")) {
                TextField("Descripción del hack", text: $descripcion)
            }
            Section(header: Text("Número de jueces")) {
                Picker("Número de jueces", selection: $numJueces) {
                    ForEach(1..<11) { index in
                        Text("\(index)")
                    }
                }
            }
            Section(header: Text("Fecha de tu Hackathon")) {
                DatePicker("Selecciona la fecha", selection: $date)
            }
            Section(header: Text("Duración del pitch (minutos)")) {
                TextField("Tiempo de pitch (minutos)", value: $tiempoPitch, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
            }
            Section(header: Text("Rubros")) {
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
        }
    }
}
