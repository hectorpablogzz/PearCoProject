//
//  HomeView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
            ScrollView {
                VStack {
                    AppStyle.CardView {
                        Text("Contenido de la tarjeta")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)

                    // Otra tarjeta
                    AppStyle.CardView {
                        Text("Otro contenido dentro de la tarjeta")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
            }
            .background(AppStyle.backgroundColor)
            .edgesIgnoringSafeArea(.all)
        }
}



#Preview {
    HomeView()
}
