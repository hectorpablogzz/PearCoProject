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
    
    @State private var position: CGPoint = CGPoint(
        x: UIScreen.main.bounds.width - 80,
        y: UIScreen.main.bounds.height - 150
    )
    @State private var showSheet = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Floating mic button
                Button(action: {
                    showSheet = true
                }) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(color)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
            }
            .position(x: position.x, y: position.y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let x = min(max(value.location.x, 50), geo.size.width - 50)
                        let y = min(max(value.location.y, 50), geo.size.height - 50)
                        position = CGPoint(x: x, y: y)
                    }
                    .onEnded { _ in
                        // Snap to nearest corner
                        let margin: CGFloat = 60
                        let corners = [
                            CGPoint(x: margin, y: margin),
                            CGPoint(x: geo.size.width - margin, y: margin),
                            CGPoint(x: margin, y: geo.size.height - margin),
                            CGPoint(x: geo.size.width - margin, y: geo.size.height - margin)
                        ]
                        if let nearest = corners.min(by: { distance(from: position, to: $0) < distance(from: position, to: $1) }) {
                            withAnimation(.spring()) { position = nearest }
                        }
                    }
            )
            .sheet(isPresented: $showSheet) {
                // Open MicrophoneView
                MicrophoneView(color: Color.verdeOscuro)
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
