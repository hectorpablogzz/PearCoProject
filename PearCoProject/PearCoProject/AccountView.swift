//
//  AccountView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//
import SwiftUI

struct AccountView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer().frame(height: 140)
                
                Image("agricultor")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.black, lineWidth: 1)
                    )
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre de agricultor")
                            .font(.headline)
                        
                        Text("Juan Pérez")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Parcela a su cargo")
                            .font(.headline)
                        
                        Text("Parcela Los Pinos")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Técnico a cargo")
                            .font(.headline)
                        
                        Text("María López")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            
            Text("Perfil agricultor")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 80)
            HStack {
                Spacer()
                Button(action: {
                    print("Cerrar sesión presionado")
                }) {
                    Text("Cerrar Sesión")
                        .foregroundColor(.red)
                        .font(.headline)
                }
                .padding(.trailing, 16)
                .padding(.top, 20)
            }
        }
    }
}

#Preview {
    AccountView()
}
