//
//  StartButton.swift
//  HackApp
//
//  Created by Alumno on 05/09/24.
//

import SwiftUI

struct StartButton: View {
    var title: String
    var iconName: String
    var hint: String
    var action: ()-> Void
    
    var body: some View {
        Button(action: action){
            ZStack{
                VStack{
                    Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .frame(width: 90, height: 90)
                    Text(title)
                        .foregroundColor(.white)
                        .font(.custom("Lato", size: FontSizeApp.largeButtonText.rawValue))
                        .bold()
                        .frame(width: 330)
                }// End VStack
                .frame(width: 500, height: 280)
                .background(Color("LightBlue"))
                .cornerRadius(30)
                .padding(5)
                .foregroundColor(.white)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .accessibilityLabel(title)
                .accessibilityHint(hint)
            }// End ZStack
        }// End Button
    }
}

#Preview {
    StartButton(
        title: "Button",
        iconName: "envelope.fill",
        hint: "Esto es un boton", action: {}
    )
}
