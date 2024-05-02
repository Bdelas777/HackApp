//
//  JudgeHomeView.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 01/05/24.
//

import SwiftUI

struct JudgeHomeView: View {
    let nombreHack = "HackMTY 2024"
    let dummyData = ["Elemento 1", "Elemento 2", "Elemento 3", "Elemento 4", "Elemento 5", "Elemento 6","Elemento 7", "Elemento 8", "Elemento 9" ]
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                ZStack{
                    List{
                        ForEach(dummyData, id: \.self){data in
                            NavigationLink(destination: ContentView()){
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
