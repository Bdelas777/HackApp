//
//  JudgeHomeView.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 01/05/24.
//

import SwiftUI

struct JudgeHomeView: View {
    let nombreHack = "HackMTY 2024"
    let dummyData = ["Equipo 1", "Equipo 2", "Equipo 3", "Equipo 4", "Equipo 5", "Equipo 6","Equipo 7", "Equipo 8", "Equipo 9" ]
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                ZStack{
                    List{
                        ForEach(dummyData, id: \.self){data in
                            NavigationLink(destination: RateJudgeView()){
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
    }}

#Preview {
    JudgeHomeView()
}
