//
//  AlertView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct AlertView: View {
    var body: some View {
        Text("Alertas")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.brown)
        
        VStack(alignment: .leading, spacing: 20) {
            Text("Enfermedades")
                .font(.headline)
            
            Alert(image: "AlertExample",
                  title: "Solucionar plaga",
                  description: "Aplica el trataminto necesario")
            
            Text("Fertilización")
                .font(.headline)
            
            Alert(image: "AlertExample",
                  title: "Fertilizar",
                  description: "Revisar estado de fertilización")
        }
        .padding(.horizontal, 15)
        .padding(.top, 15)
        
        Spacer()
    }
}

#Preview {
    AlertView()
}

struct Alert: View {
    @State private var isCompleted = false
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "ellipsis")
                    .padding(.trailing, 8)
                    .padding(.top, 8)
            }
            
            HStack(spacing: 12) {
                Image(image)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .scaledToFit()
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .padding(.leading, 4)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                }
                
                Spacer()
                
                Text(isCompleted ? "Listo" : "Completar")
                    .font(.caption)
                    .foregroundColor(isCompleted ? .gray : .white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(isCompleted ? Color.white : Color.green)
                    .cornerRadius(20)
                    .onTapGesture {
                        isCompleted.toggle()
                    }
            }
            .padding([.horizontal, .bottom])
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
    }
}
