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
            VStack(alignment: .leading) {
                
                Text("Agricultores")
                    .font(.system(size: geo.size.width * 0.06, weight: .bold))
                    .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: geo.size.height * 0.025) {
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
                    .padding(.bottom, geo.size.height * 0.03)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct Farmer: View {
    let imageSystemName: String
    let name: String
    let description: String
    let geo: GeometryProxy
    
    var body: some View {
        HStack(spacing: geo.size.width * 0.03) {
            Image(systemName: imageSystemName)
                .resizable()
                .frame(width: geo.size.width * 0.12, height: geo.size.width * 0.12)
                .foregroundColor(.verdeOscuro)
            
            VStack(alignment: .leading, spacing: geo.size.height * 0.005) {
                Text(name)
                    .font(.system(size: geo.size.width * 0.04, weight: .semibold))
                Text(description)
                    .font(.system(size: geo.size.width * 0.03))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            NavigationLink {
                AccountView()
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: geo.size.width * 0.06))
                    .foregroundColor(.verdeOscuro)
            }
        }
        .padding(.all, geo.size.width * 0.03)
        .background(Color(.systemBackground))
        .cornerRadius(geo.size.width * 0.04)
        .shadow(color: .black.opacity(0.1), radius: geo.size.width * 0.015, x: 0, y: geo.size.height * 0.005)
    }
}

#Preview {
    NavigationStack { // <-- Aquí envolvemos la vista para probarla
        FarmersView()
    }
}
