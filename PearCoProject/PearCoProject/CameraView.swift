//
//  CameraView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
            VStack {
                Text("Diagnóstico por foto")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Text("Centre la planta en la cámara para continuar")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                Spacer()
                
                Image("plantImage") // Aquí agregas tu imagen de ejemplo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .overlay(
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.top, 30)
                
                Spacer()
                
                Button(action: {
                    // Acción de tomar foto
                }) {
                    Text("Tomar foto")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    } 


#Preview {
    CameraView()
}
