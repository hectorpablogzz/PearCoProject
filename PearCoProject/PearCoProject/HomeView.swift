//
//  HomeView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct HomeView: View {
    
    let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255)
    let sageGreen = Color(red: 176/255, green: 190/255, blue: 169/255)
    let verdeBoton = Color(red: 59/255, green: 150/255, blue: 108/255)

    // Datos de ejemplo
    let enfermedades = [
        ("Broca", 0.75),
        ("Roya", 0.45),
        ("Ojo de gallo", 0.60),
        ("Antracnosis", 0.30)
    ]
    
    var body: some View {
        NavigationStack {
                    HStack(spacing: 0) {
                        // Franja verde lateral
                        Rectangle()
                            .fill(verdeOscuro)
                            .frame(width: 50)
                        
                        // Contenido principal
                        VStack(spacing: 40) {
                            
                            // Título
                            Text("Menú Principal")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(verdeOscuro)
                            
                            Text("Toma una foto de la planta para analizar su salud")
                                .font(.title2)
                                .foregroundColor(.black)

                            ZStack {
                                Image("planta")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 250)
                                    .clipped()
                                    .cornerRadius(20)
                                
                                NavigationLink(destination: CameraView()) {
                                    Image(systemName: "camera")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                        .padding(30)
                                        .background(verdeOscuro)
                                        .clipShape(Circle())
                                }
                            }
                            
                            NavigationLink(destination: CameraView()) {
                                Text("Tomar foto")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: 500, maxHeight: 100)
                                    .background(verdeBoton)
                                    .cornerRadius(15)
                            }
                            
                            // Gráfica
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
                            
                            NavigationLink(destination: MicrophoneView()) {
                                Image(systemName: "mic.fill")
                                    .font(.system(size: 40))
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
    
}

#Preview {
    HomeView()
}
