//
//  FarmersView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct FarmersView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Fondo de la página
                Color.grisFondo
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    Text("Agricultores")
                        .font(.system(size: geo.size.width * 0.07, weight: .bold))
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .foregroundColor(Color.verdeOscuro)
                    
                    ScrollView {
                        VStack(spacing: geo.size.height * 0.025) {
                            Farmer(imageSystemName: "person.crop.circle.fill",
                                   name: "Juan Perez",
                                   description: "Encargado parcela 2",
                                   geo: geo)
                            
                            Farmer(imageSystemName: "person.crop.circle.fill",
                                   name: "María Lopez",
                                   description: "Responsable riego de cultivos",
                                   geo: geo)
                            
                            Farmer(imageSystemName: "person.crop.circle.fill",
                                   name: "Carlos Sanchéz",
                                   description: "Encargado parcela 3",
                                   geo: geo)
                        }
                        .padding(.horizontal, geo.size.width * 0.05)
                        .padding(.bottom, geo.size.height * 0.12) // espacio para el botón flotante
                    }
                }
                
                // Botón flotante estilo Siri
                MicrophoneButton(color: Color.verdeOscuro)
            }
        }
    }
}

struct Farmer: View {
    let imageSystemName: String
    let name: String
    let description: String
    let geo: GeometryProxy
    
    var body: some View {
        HStack(spacing: geo.size.width * 0.04) {
            Image(systemName: imageSystemName)
                .resizable()
                .frame(width: geo.size.width * 0.14, height: geo.size.width * 0.14)
                .foregroundColor(.verdeOscuro)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: geo.size.width * 0.01, x: 0, y: geo.size.height * 0.002)
            
            VStack(alignment: .leading, spacing: geo.size.height * 0.003) {
                Text(name)
                    .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                    .foregroundColor(.verdeOscuro)
                Text(description)
                    .font(.system(size: geo.size.width * 0.035))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            NavigationLink {
                AccountView()
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: geo.size.width * 0.065))
                    .foregroundColor(.verdeClaro)
            }
        }
        .padding(geo.size.width * 0.04)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.08), radius: geo.size.width * 0.01, x: 0, y: geo.size.height * 0.003)
    }
}

#Preview {
    NavigationStack {
        FarmersView()
    }
}
