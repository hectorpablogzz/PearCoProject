//
//  CameraView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct CameraView: View {
    
    let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255)
    
    @State private var micPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 150)
    @State private var showMicrophoneView = false
    
    var body: some View {
        ZStack {
            // Fondo
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 0) {
                // Franja lateral
                Rectangle()
                    .fill(verdeOscuro)
                    .frame(width: 80)
                
                // Contenido
                VStack(spacing: 30) {
                    Text("Diagnóstico por foto")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(verdeOscuro)
                    
                    Text("Centre la planta en la cámara para continuar")
                        .font(.title2)
                        .foregroundColor(.black)
                    
                    ZStack {
                        Image("CoffeePlant")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 650, height: 650)
                            .clipped()
                            .cornerRadius(20)
                        
                        Button(action: {
                            print("Ir a cámara")
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding(30)
                                .background(verdeOscuro)
                                .clipShape(Circle())
                        }
                    }
                    
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
                    
                    Spacer().frame(height: 150) // espacio para el micrófono flotante
                    
                
                }
                .padding(80)
            }
            
           
        }
    }
}


#Preview {
    CameraView()
}

