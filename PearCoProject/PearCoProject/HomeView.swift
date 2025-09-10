//
//  HomeView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct HomeView: View {
    
    let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255) // Color de tu app
    let sageGreen = Color(red: 176/255, green: 190/255, blue: 169/255)

    // Datos de ejemplo
    let enfermedades = [
        ("Broca", 0.75),
        ("Roya", 0.45),
        ("Ojo de gallo", 0.60),
        ("Antracnosis", 0.30)
    ]
    
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
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 500, maxHeight: 100)
                        .background(verdeOscuro)
                        .cornerRadius(15)
                }
                
               //Gráfica
                VStack(spacing: 50) {
                    Text("Probabilidad de Enfermedades")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(verdeOscuro)
                    
                    HStack(alignment: .bottom, spacing: 50) {
                        ForEach(enfermedades, id: \.0) { (nombre, valor) in
                            VStack {
                                Rectangle()
                                    .fill(sageGreen)
                                    .frame(width: 60, height: CGFloat(valor) * 200)
                                    .cornerRadius(6)
                                
                                Text(nombre)
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 90)
                            }
                        }
                    }
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
