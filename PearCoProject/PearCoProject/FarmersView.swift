//
//  FarmersView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct FarmersView: View {
    var body: some View {
        Text("Agricultores")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.brown)
        
        VStack(alignment: .leading, spacing: 16) {
            Farmer(imageSystemName: "person.crop.circle.fill",
                   name: "Juan Perez",
                   description: "Encargado parcela 2")
            
            Farmer(imageSystemName: "person.crop.circle.fill",
                   name: "María Lopez",
                   description: "Responsable riego de cultivos")
            
            Farmer(imageSystemName: "person.crop.circle.fill",
                   name: "Carlos Sanchéz",
                   description: "Encargado parcela 3")
        }
        .padding()
        Spacer()
    }
}

struct Farmer: View {
    let imageSystemName: String
    let name: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageSystemName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.brown)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    FarmersView()
}
