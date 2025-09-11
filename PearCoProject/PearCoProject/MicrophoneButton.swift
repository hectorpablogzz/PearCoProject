//
//  MicrophoneButton.swift
//  PearCoProject
//
//  Created by marielgonzalezg on 10/09/25.
//
import Foundation
import SwiftUICore
import UIKit
import SwiftUI

struct MicrophoneButton: View {
    let color: Color
    
    @State private var position: CGPoint = CGPoint(
        x: UIScreen.main.bounds.width - 80,
        y: UIScreen.main.bounds.height - 150
    )
    @State private var showMicView = false
    
    var body: some View {
        Button(action: {
            showMicView = true
        }) {
            Image(systemName: "mic.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(color)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .position(position)
        .gesture(
            DragGesture()
                .onChanged { value in
                    position = value.location
                }
                .onEnded { _ in
                    // Ajusta a la esquina más cercana
                    let margin: CGFloat = 60
                    let corners = [
                        CGPoint(x: margin, y: margin),
                        CGPoint(x: UIScreen.main.bounds.width - margin, y: margin),
                        CGPoint(x: margin, y: UIScreen.main.bounds.height - margin),
                        CGPoint(x: UIScreen.main.bounds.width - margin, y: UIScreen.main.bounds.height - margin)
                    ]
                    if let nearest = corners.min(by: { distance(from: position, to: $0) < distance(from: position, to: $1) }) {
                        withAnimation(.spring()) {
                            position = nearest
                        }
                    }
                }
        )
        .sheet(isPresented: $showMicView) {
            MicrophoneView()
        }
    }
    
    // Función auxiliar para calcular distancia entre puntos
    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = from.x - to.x
        let dy = from.y - to.y
        return sqrt(dx*dx + dy*dy)
    }
}

#Preview {
    ZStack {
        Color.white.edgesIgnoringSafeArea(.all)
        MicrophoneButton(color: Color(red: 32/255, green: 75/255, blue: 54/255))
    }
}
