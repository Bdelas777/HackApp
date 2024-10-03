//
//  JudgeHomeView.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 01/05/24.
//

import SwiftUI

struct JudgeHomeView: View {
    let hackClaveInput: String
    @State private var selectedEquipos: [String]?
    @ObservedObject var viewModel = HacksViewModel()
    let nombreHack = "HackMTY 2024"
    let dummyData = ["Equipo 1", "Equipo 2", "Equipo 3", "Equipo 4", "Equipo 5", "Equipo 6","Equipo 7", "Equipo 8", "Equipo 9" ]
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                ZStack{
                    List{
                        ForEach(selectedEquipos ?? dummyData, id: \.self){data in
                            NavigationLink(destination: GradeView(hackClaveInput: hackClaveInput)){
                                Text(data)
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .padding()
                            }
                        }
                    }
                    .listRowSpacing(10)
                }
            }
            .navigationTitle("Equipos de \(nombreHack)")
        }
        .onAppear {
            fetchEquipos()
        }
    }
    private func fetchEquipos() {
        viewModel.getEquipos(for: hackClaveInput) { result in
            switch result {
                
            case .success(let equipos):
                if equipos.isEmpty {
                    print("Aca estiy vacio")
                    selectedEquipos = nil
                } else {
                    print("Aca estiy")
                    selectedEquipos = equipos
                   
                }
             
            case .failure:
                selectedEquipos = nil
                print("Aca estiy fallando")
               
            }
        }
    }

    
}

#Preview {
    JudgeHomeView(hackClaveInput: "HACK24")
}
