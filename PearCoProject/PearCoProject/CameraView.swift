//
//  CameraView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct CameraView: View {
    
    let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255)
    let verdeBoton = Color(red: 59/255, green: 150/255, blue: 108/255)
    
    @State private var isPhotoTaken = false
    
    var body: some View {
        ZStack {
            
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 0) {
                
                Rectangle()
                    .fill(verdeOscuro)
                    .frame(width: 50)
                    .edgesIgnoringSafeArea(.all)
                
                // Contenido principal
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // Título
                        Text("Diagnóstico por Foto")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(verdeOscuro)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Centre la planta en la cámara para continuar")
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Imagen con overlay al tomar foto y botón de cámara
                        ZStack {
                            Image("CoffeePlant")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 650, height: 650)
                                .clipped()
                                .cornerRadius(20)
                                .overlay(Color.white.opacity(isPhotoTaken ? 0.7 : 0)
                                    .cornerRadius(20))
                                .animation(.easeInOut(duration: 0.3), value: isPhotoTaken)
                            
                            Button(action: {
                                withAnimation {
                                    isPhotoTaken = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation {
                                        isPhotoTaken = false
                                    }
                                }
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .padding(30)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                            }
                        }
                        
                        // Botón "Tomar foto"
                        Button(action: { print("Tomar foto") }) {
                            Text("Tomar foto")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 400)
                                .background(verdeBoton)
                                .cornerRadius(20)
                        }
                        
                        Spacer().frame(height: 150) // espacio para micrófono
                    }
                    .padding(50)
                }
            }
            
            
            MicrophoneButton(color: verdeOscuro)
        }
    }
}

#Preview {
    CameraView()
}
