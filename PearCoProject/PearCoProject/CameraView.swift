//
//  CameraView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct CameraView: View {
    
    let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255) // Color de tu app

    var body: some View {
        ZStack {
            // Fondo beige que cubre toda la pantalla
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 0) {
                // Franja verde lateral más delgada
                Rectangle()
                    .fill(verdeOscuro)
                    .frame(width: 80) // Franja más delgada
                
                // Contenido principal
                VStack(spacing: 40) {
                    // Título
                    Text("Diagnóstico por foto")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(verdeOscuro)
                    
                    Text("Centre la planta en la cámara para continuar")
                        .font(.title2)
                        .foregroundColor(.black)

                    // Imagen con botón circular encima
                    ZStack {
                        Image("CoffeePlant") // Asegúrate de tener la imagen
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 650, height: 800)
                            .clipped()
                            .cornerRadius(20)
                        
                        // Botón circular de cámara
                        Button(action: {
                            print("Ir a cámara")
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 30)) // icono más grande
                                .foregroundColor(.white)
                                .padding(30)
                                .background(verdeOscuro)
                                .clipShape(Circle())
                        }
                    }
                    
                    // Botón "Tomar foto"
                    Button(action: {
                        print("Tomar foto")
                    }) {
                        Text("Tomar foto")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 400)
                            .background(verdeOscuro)
                            .cornerRadius(15)
                    }
                    
                    
                    Spacer()
                    
                }
                .padding(80)
            }
        }
    }
}

#Preview {
    CameraView()
}



#Preview {
    CameraView()
}
