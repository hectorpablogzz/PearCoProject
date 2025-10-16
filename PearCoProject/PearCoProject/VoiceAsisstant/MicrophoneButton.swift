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
    
    // Posición inicial centrada más arriba de la esquina inferior derecha
    @State private var position: CGPoint = CGPoint(
        x: UIScreen.main.bounds.width - 120,
        y: UIScreen.main.bounds.height - 180
    )
    @State private var showSheet = false
    @State private var bounce: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 🎤 Floating mic button (simple, bonito y animado)
                Button(action: {
                    showSheet = true
                }) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(color)
                        .clipShape(Circle())
                        .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 4)
                        .scaleEffect(bounce ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: bounce)
                }
                .onAppear { bounce = true }
            }
            .position(x: position.x, y: position.y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let margin: CGFloat = 50
                        let x = min(max(value.location.x, margin), geo.size.width - margin)
                        let y = min(max(value.location.y, margin), geo.size.height - margin)
                        position = CGPoint(x: x, y: y)
                    }
                    .onEnded { _ in
                        let snapMargin: CGFloat = 80
                        let corners = [
                            CGPoint(x: snapMargin, y: snapMargin),
                            CGPoint(x: geo.size.width - snapMargin, y: snapMargin),
                            CGPoint(x: snapMargin, y: geo.size.height - snapMargin),
                            CGPoint(x: geo.size.width - snapMargin, y: geo.size.height - snapMargin)
                        ]
                        if let nearest = corners.min(by: { distance(from: position, to: $0) < distance(from: position, to: $1) }) {
                            withAnimation(.spring()) { position = nearest }
                        }
                    }
            )
            .sheet(isPresented: $showSheet) {
                LatteDetailView(color: Color.verdeOscuro)
            }
        }
    }
    
    // MARK: - Helper
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = from.x - to.x
        let dy = from.y - to.y
        return sqrt(dx*dx + dy*dy)
    }
}
