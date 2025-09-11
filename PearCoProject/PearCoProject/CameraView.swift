//
//  CameraView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI



struct CameraView: View {
    
    let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255) // Color de tu app
    let verdeBoton = Color(red: 59/255, green: 150/255, blue: 108/255)
    @State private var isPhotoTaken = false

    var body: some View {
        ZStack {
            
            HStack(spacing: 0) {
                // Franja verde lateral más delgada
                Rectangle()
                    .fill(Color.verdeOscuro)
                    .frame(width: 50) // Franja más delgada
                
                // Contenido principal
                VStack(spacing: 50) {
                    VStack(spacing: 20) {
                        // Título
                        Text("Diagnóstico por foto")
                            .font(.system(size: 55))
                            .greenTitle()
                            .frame(maxWidth: .infinity, alignment: .leading) //
                        
                        Text("Centre la planta en la cámara para continuar")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading) //
                    }
                        
                        // Imagen con botón circular encima
                        ZStack {
                            Image("CoffeePlant") // Asegúrate de tener la imagen
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 650, height: 700)
                                .clipped()
                                .cornerRadius(45) // Redondea las esquinas
                                .overlay(
                                    RoundedRectangle(cornerRadius: 45) // Borde redondeado
                                        .stroke(.black, lineWidth: 4) // Borde negro con 4 de grosor
                                        )
                                .shadow(color: .black.opacity(0.4), radius: 50, x: 5, y: 5) // Sombra alrededor de la imagen
                                .overlay(Color.white.opacity(isPhotoTaken ? 0.7 : 0) // Aparece blanco cuando la foto se toma
                                .cornerRadius(45) // Asegura que el overlay sea redondeado
                                    )
                                .animation(.easeInOut(duration: 0.3), value: isPhotoTaken) // Animación con el estado de la foto
                            
                            // Botón circular de cámara
                            Button(action: {
                                withAnimation {
                                    isPhotoTaken = true }
                                print("Ir a cámara")
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Espera 2 segundos
                                    withAnimation {
                                        isPhotoTaken = false // Revertir el estado
                                    }
                                }
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: 80)) // icono más grande
                                    .foregroundColor(.white)
                                    .padding(30)
                                    .background(Color.black.opacity(0.3)) // Círculo gris opaco
                                    .clipShape(Circle())
                            }
                        }
                        
                        // Botón "Tomar foto"
                        Button(action: {
                            print("Tomar foto")
                        }) {
                            Text("Tomar foto")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 400)
                                .background(verdeBoton)
                                .cornerRadius(20)
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


