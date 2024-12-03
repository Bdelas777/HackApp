//
//  SimplePage.swift
//  HackApp
//
//  Created by Alumno on 09/10/24.
//
import SwiftUI
/// Vista que muestra las calificaciones de un equipo en un hackathon.
///
/// Esta vista permite a los jueces revisar y calificar a los equipos. Muestra las calificaciones de cada rubro,
/// el puntaje final calculado y el tiempo restante para presentar el pitch del equipo seleccionado.
/// También se muestra la puntuación general, que es el promedio ponderado de las calificaciones de los jueces.
///
/// **Propiedades**:
/// - `hack`: El modelo del hackathon, contiene información sobre el evento, equipos, jueces, rubros y calificaciones.
/// - `viewModel`: Un `TeamViewModel` que maneja la lógica de obtención de calificaciones, rubros y cálculo de la puntuación.
/// - `equipoSeleccionado`: El nombre del equipo seleccionado por el juez para calificar.
///
/// **Acciones**:
/// - La vista muestra un progreso mientras se cargan las calificaciones.
/// - Si no hay calificaciones, muestra un temporizador (`TimerView`) con el tiempo restante para el pitch.
/// - Si existen calificaciones, se muestra una lista con las calificaciones de los jueces, los rubros evaluados,
///   el peso de cada rubro y el puntaje final.

struct TeamView: View {
    var hack: HackModel
    @ObservedObject var viewModel: TeamViewModel
    let equipoSeleccionado: String
    
    init(hack: HackModel, equipoSeleccionado: String) {
        self.hack = hack
        self.equipoSeleccionado = equipoSeleccionado
        _viewModel = ObservedObject(wrappedValue: TeamViewModel(hack: hack, equipoSeleccionado: equipoSeleccionado, viewModel: HacksViewModel()))
    }

    var body: some View {
        VStack {
            Text(equipoSeleccionado)
                .font(.largeTitle)
                .padding()

            if viewModel.isLoading {
                ProgressView("Cargando calificaciones...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding()
            } else {
                if viewModel.calificaciones.isEmpty {
                    TimerView(tiempoPitch: Int(hack.tiempoPitch))
                } else {
                    List {
                        ForEach(viewModel.calificaciones.keys.sorted(), id: \.self) { juez in
                            Section(header: Text(juez).font(.subheadline).foregroundColor(.gray)) {
                                ForEach(viewModel.calificaciones[juez]?.keys.sorted() ?? [], id: \.self) { rubro in
                                    let calificacion = viewModel.calificaciones[juez]?[rubro] ?? 0.0
                                    let pesoRubro = viewModel.rubros[rubro] ?? 0.0
                                    let valorFinal = viewModel.calculateFinalScore(calificacion: calificacion, peso: pesoRubro / 100)

                                    VStack(alignment: .leading) {
                                        Text("\(rubro): \(String(format: "%.2f", calificacion)) de \(hack.valorRubro )")
                                            .foregroundColor(.black)
                                        Text("Peso: \(String(format: "%.2f", pesoRubro))% | Valor Final: \(String(format: "%.2f", valorFinal))")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }

                    Text("Puntuación General: \(viewModel.totalJudges > 0 ? String(format: "%.2f", viewModel.totalScore  / Double(viewModel.totalJudges)) : "0.00")")
                        .font(.headline)
                        .padding()
                }
            }
        }
        .navigationTitle(viewModel.calificaciones.isEmpty ? "Tiempo restante" : "Calificaciones")
        .onAppear {
            viewModel.fetchRubros()
            viewModel.fetchCalificaciones()
        }
    }
}


#Preview {
    TeamView(hack: HackModel(
        id: "Ejemplo Hack",
        clave: "Hack",
        descripcion: "Descripción del hack",
        equipos: ["P", "Q"],
        jueces: ["A", "B"],
        rubros: ["rubro": 50],
        estaActivo: true,
        nombre: "Ejemplo",
        tiempoPitch: 9,
        FechaStart: Date(),
        FechaEnd: Date(),
        valorRubro: 5,
        calificaciones: [
            "P": ["A": ["rubro": 9]],
            "Q": ["B": ["rubro": 78]]
        ]
    ), equipoSeleccionado: "Equipo 1")
}
