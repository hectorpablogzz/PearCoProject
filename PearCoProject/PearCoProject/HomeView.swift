//
//  HomeView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct HomeView: View {
    
    let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255) // Color de tu app

    var body: some View {
        HStack(spacing: 0) {
            // Franja verde lateral
            Rectangle()
                .fill(verdeOscuro)
                .frame(width: 100) // más ancho para iPad
            
            // Contenido principal
            VStack(spacing: 40) {
                
                // Título
                Text("Menú Principal")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(verdeOscuro)
                
                Text("Toma una foto de la planta para analizar su salud")
                    .font(.title2)
                    .foregroundColor(.black)

                // Imagen con botón circular encima
                ZStack {
                    Image("planta")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
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
                
                // Alerta
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                    VStack(alignment: .leading) {
                        Text("Marchitez detectada")
                            .foregroundColor(.red)
                            .bold()
                            .font(.title3)
                        Text("Hace 20 min")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Historial
                HStack {
                    Image(systemName: "leaf.fill")
                        .font(.title3)
                    Text("Café - 29 feb 2024, 11:30")
                        .font(.title3)
                }
                
                Spacer()
                
                // Botón de micrófono grande
                Button(action: {
                    print("Micrófono")
                }) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 40)) // icono más grande
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(verdeOscuro)
                        .clipShape(Circle())
                }
                .padding(.bottom, 40)
            }
            .padding(50)
        }
    }
}

#Preview {
    HomeView()
}
