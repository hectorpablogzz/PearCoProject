//
//  MicrophoneButton.swift
//  PearCoProject
//
//  Created by marielgonzalezg on 10/09/25.
//
//

import SwiftUI

struct MicrophoneButton: View {
    let color: Color
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    showSheet = true
                }) {
                    ZStack {
                        // Sombra
                        Circle()
                            .fill(color)
                            .frame(width: 72, height: 72)
                            .shadow(color: color.opacity(0.3), radius: 12, x: 0, y: 6)
                        
                        // Botón principal
                        Circle()
                            .fill(color)
                            .frame(width: 72, height: 72)
                        
                        // Ícono
                        Image(systemName: "mic.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
                .sheet(isPresented: $showSheet) {
                    MicrophoneView(color: color)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        MicrophoneButton(color: .green)
    }
}
