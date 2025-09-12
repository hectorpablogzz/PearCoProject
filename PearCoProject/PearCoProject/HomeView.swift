//
//  HomeView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//
import SwiftUI

struct HomeView: View {
    
    let sageGreen = Color(red: 176/255, green: 190/255, blue: 169/255)

    // Datos de ejemplo
    let enfermedades = [
        ("Broca", 0.75),
        ("Roya", 0.45),
        ("Ojo de gallo", 0.60),
        ("Antracnosis", 0.30)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                HStack(spacing: 0) {
                    // Contenido principal
                    VStack(spacing: 40) {
                        // Título
                        Text("Menú Principal")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Color.verdeOscuro)
                        
                        Text("Toma una foto de la planta para analizar su salud")
                            .font(.title2)
                            .foregroundColor(.black)

                        ZStack {
                            Image("planta")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 350)
                                .clipped()
                                .cornerRadius(20)
                            
                            NavigationLink(destination: CameraView()) {
                                Image(systemName: "camera")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding(30)
                                    .background(Color.verdeOscuro)
                                    .clipShape(Circle())
                            }
                        }
                        
                        NavigationLink(destination: CameraView()) {
                            Text("Tomar foto")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 500, maxHeight: 100)
                                .background(Color.verdeBoton)
                                .cornerRadius(15)
                        }
                        
                        // Gráfica
                        VStack(spacing: 50) {
                            Text("Probabilidad de Enfermedades")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.verdeOscuro)
                            
                            HStack(alignment: .bottom, spacing: 50) {
                                ForEach(enfermedades, id: \.0) { (nombre, valor) in
                                    VStack {
                                        Rectangle()
                                            .fill(Color.sageGreen)
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
                            .padding(.bottom, 40)
                    }
                    .padding(50)
                }
                
                
                MicrophoneButton(color: Color.verdeOscuro)
            }
            .greenSidebar()
        }
    }
}

#Preview {
    HomeView()
}
