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
                .frame(width: 80)
            
            // Contenido principal
            VStack(spacing: 30) {
                
                // Título
                Text("Menú Principal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(verdeOscuro)
                
                Text("Toma una foto de la planta para analizar su salud")
                    .font(.headline)
                    .foregroundColor(.black)

                // Imagen con botón circular encima
                ZStack {
                    Image("planta")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                    
                    // Botón circular
                    Button(action: {
                        print("Ir a cámara")
                        // Navegar a otra vista aquí
                    }) {
                        Image(systemName: "camera")
                            .foregroundColor(.white)
                            .padding()
                            .background(verdeOscuro)
                            .clipShape(Circle())
                    }
                }
                
                // Botón "Tomar foto"
                Button(action: {
                    print("Tomar foto")
                }) {
                    Text("Tomar foto")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(verdeOscuro)
                        .cornerRadius(10)
                }
                
                
                // Alerta
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading) {
                        Text("Marchitez detectada")
                            .foregroundColor(.red)
                            .bold()
                        Text("Hace 20 min")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Historial
                HStack {
                    Image(systemName: "leaf.fill")
                    Text("Café - 29 feb 2024, 11:30")
                }
                .font(.subheadline)
                
                Spacer()
                
                //Botón Microfono
                Button(action: {
                    print("Tomar foto")
                }) {
                    Image(systemName: "microphone")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 2000)
                        .background(verdeOscuro)
                        .clipShape(Circle())
                        .cornerRadius(10)
                }
            }
            .padding(40)
        }
    }
}

#Preview {
    HomeView()
}
