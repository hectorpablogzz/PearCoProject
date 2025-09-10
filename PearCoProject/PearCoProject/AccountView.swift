//
//  AccountView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//
import SwiftUI

extension Color {
    static let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255)
}

struct AccountView: View {
    @State private var showParcela = false
    @State private var showConfig = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Encabezado
                    Text("Perfil agricultor")
                        .font(.system(size: geo.size.width * 0.06, weight: .bold))
                        .padding(.top, 40)
                    
                    VStack(spacing: 8) {
                        Image("agricultor_ejemplo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width * 0.35,
                                   height: geo.size.width * 0.35)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        
                        Text("Antonio Pérez")
                            .font(.system(size: geo.size.width * 0.05, weight: .semibold))
                        
                        Text("antonio.perez@email.com")
                            .foregroundColor(.gray)
                            .font(.system(size: geo.size.width * 0.04))
                    }
                    .padding(.bottom, 20)
                    
                    VStack(spacing: 12) {
                        
                        // Parcela
                        DisclosureGroup(isExpanded: $showParcela) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Parcela Los Pinos")
                                    .font(.system(size: geo.size.width * 0.045, weight: .medium))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.top, 5)
                        } label: {
                            Text("Parcela de cultivo")
                                .font(.system(size: geo.size.width * 0.05, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Configuración
                        DisclosureGroup(isExpanded: $showConfig) {
                            VStack(alignment: .leading, spacing: 12) {
                                Button("Notificaciones") { }
                                    .foregroundColor(.verdeOscuro)
                                    .font(.system(size: geo.size.width * 0.045))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button("Preferencias") { }
                                    .foregroundColor(.verdeOscuro)
                                    .font(.system(size: geo.size.width * 0.045))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button("Soporte") { }
                                    .foregroundColor(.verdeOscuro)
                                    .font(.system(size: geo.size.width * 0.045))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.top, 5)
                        } label: {
                            Text("Configuración")
                                .font(.system(size: geo.size.width * 0.05, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 50)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Cerrar sesión presionado")
                    }) {
                        Text("Cerrar sesión")
                            .foregroundColor(.white)
                            .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.verdeOscuro)
                            .cornerRadius(25)
                            .padding(.horizontal, 70)
                    }
                    .padding(.bottom, 40)
                }
                .frame(width: geo.size.width)
            }
            .background(Color.white)
        }
    }
}

#Preview {
    AccountView()
}
