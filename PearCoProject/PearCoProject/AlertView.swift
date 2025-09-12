//
//  AlertView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct AlertView: View {
    
    var body: some View {
        HStack (spacing: 0) {
            
            ZStack {
                // Fondo
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                // Contenido principal
                HStack(spacing: 0) {
                    GeometryReader { geo in
                        ScrollView {
                            VStack(alignment: .leading, spacing: geo.size.height * 0.025) {
                                Text("Alertas")
                                    .font(.system(size: 55, weight: .bold))
                                    .foregroundColor(Color.verdeOscuro)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 20)
                                    .padding()
                                
                                Text("Enfermedades")
                                    .font(.system(size: geo.size.width * 0.04, weight: .semibold))
                                    .padding(.horizontal)
                                
                                Alert(category: "Enfermedades",
                                      image: "AlertExample",
                                      title: "Solucionar plaga",
                                      description: "Aplica el tratamiento necesario para combatir la broca del cafe",
                                      geo: geo)
                                
                                Text("Fertilización")
                                    .font(.system(size: geo.size.width * 0.04, weight: .semibold))
                                    .padding(.horizontal)
                                
                                Alert(category: "Fertilización",
                                      image: "AlertaFertilizar",
                                      title: "Fertilizar",
                                      description: "Revisar estado de fertilización de la parcela",
                                      geo: geo)
                                
                                Text("Clima")
                                    .font(.system(size: geo.size.width * 0.04, weight: .semibold))
                                    .padding(.horizontal)
                                
                                Alert(category: "Clima",
                                      image: "AlertaClima",
                                      title: "Clima extremadamente caluroso",
                                      description: "Recuerda regar las plantas",
                                      geo: geo)
                                
                                Alert(category: "Clima",
                                      image: "AlertaClima",
                                      title: "Clima propenso a enfermedades",
                                      description: "Las condiciones actuales del clima pueden generar enfermedades, toma precauciones",
                                      geo: geo)
                                
                                Spacer().frame(height: 150) // espacio para el botón flotante
                            }
                            .frame(width: geo.size.width)
                        }
                    }
                }
                
                
                MicrophoneButton(color: Color.verdeOscuro)
            }
        }
        .greenSidebar()
    }
}

#Preview {
    AlertView()
}

// ------------------
// Estructura Alert
// ------------------
struct Alert: View {
    @State private var isCompleted = false
    let category: String
    let image: String
    let title: String
    let description: String
    let geo: GeometryProxy
    
    var buttonColor: Color {
        category == "Enfermedades" ? .red : Color(red: 59/255, green: 150/255, blue: 108/255)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.system(size: geo.size.width * 0.04))
                    .padding(.trailing, geo.size.width * 0.03)
                    .padding(.top, geo.size.height * 0.01)
            }
            
            HStack(spacing: geo.size.width * 0.02) {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.18, height: geo.size.width * 0.18)
                    .cornerRadius(geo.size.width * 0.03)
                
                VStack(alignment: .leading, spacing: geo.size.height * 0.01) {
                    Text(title)
                        .font(.system(size: geo.size.width * 0.03, weight: .bold))
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.system(size: geo.size.width * 0.03))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(isCompleted ? "Listo" : "Completar")
                    .font(.system(size: geo.size.width * 0.03, weight: .semibold))
                    .foregroundColor(isCompleted ? .gray : .white)
                    .padding()
                    .background(isCompleted ? Color(.white) : buttonColor)
                    .cornerRadius(geo.size.width * 0.02)
                    .onTapGesture {
                        isCompleted.toggle()
                    }
            }
            .padding(.horizontal, geo.size.width * 0.03)
            .padding(.bottom, geo.size.height * 0.02)
        }
        .background(Color(.systemBackground))
        .cornerRadius(geo.size.width * 0.05)
        .shadow(color: .black.opacity(0.15), radius: geo.size.width * 0.02, x: 0, y: geo.size.height * 0.005)
        .padding(.horizontal, geo.size.width * 0.02)
    }
}
