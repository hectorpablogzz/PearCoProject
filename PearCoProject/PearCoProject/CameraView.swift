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
            // Franja verde a la izquierda
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 15) // Ancho de la franja verde
                    .edgesIgnoringSafeArea(.vertical) // Asegura que la franja se extienda por toda la altura
                
                // Contenido principal a la derecha
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
                .padding(.leading, 10) // Separación del borde de la franja verde
            }
        }
        .background(Color("beige")) // Color de fondo plano claro, puedes usar "beige" o cualquier color suave
        .edgesIgnoringSafeArea(.all) // Asegura que el fondo ocupe toda la pantalla
    }
}
#Preview {
    CameraView()
}
