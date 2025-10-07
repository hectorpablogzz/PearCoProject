//
//  ResponseVMView.swift
//  PearCoProject
//
//  Created by marielgonzalezg on 07/10/25.
//

import Foundation
import SwiftUI

// MARK: - Response VM View
struct ResponseVMView: View {
    let vm: VoiceAssistantVM
    let color: Color
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.8)],
                           startPoint: .top, endPoint: .bottom)
            VStack(spacing: 30) {
                Text("Asistente de Voz")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                if let response = vm.response {
                    ScrollView {
                        Text(response)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 300)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(15)
                    .padding()
                } else {
                    Text("No se pudo obtener respuesta.")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                Button("Cerrar") { dismiss() }
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.bottom, 20)
            }
            .padding()
        }
    }
}
