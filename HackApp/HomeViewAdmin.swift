//
//  HomeViewAdmin.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 17/04/24.
//

import SwiftUI

struct HomeViewAdmin: View {
    let dummyData = ["Elemento 1", "Elemento 2", "Elemento 3", "Elemento 4", "Elemento 5", "Elemento 6","Elemento 7", "Elemento 8", "Elemento 9" ]
    var body: some View {
        ZStack{
            List{
                ForEach(dummyData, id: \.self){data in
                    Text(data)
                        .font(.title3)
                        .padding()
                }
            }
            Button{
                
            }label: {
                Label("Nuevo Hackathon", systemImage: "plus")
                    .font(.title)
                    .bold()
            }
            .buttonStyle(MainViewButtonStyle())
            .offset(x: 380, y: 280)
        }
    }
}

#Preview {
    HomeViewAdmin()
}
