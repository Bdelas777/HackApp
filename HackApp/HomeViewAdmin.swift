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
        List{
            ForEach(dummyData, id: \.self){data in
                    Text(data)
                    .padding()
            }
        }
    }
}

#Preview {
    HomeViewAdmin()
}
