//
//  MicrophoneView.swift
//  PearCoProject
//
//  Created by Alumno on 10/09/25.
//

import SwiftUI

struct MicrophoneView: View {
    @State private var animate = false

       var body: some View {
           ZStack {
               Color.black.opacity(0.5)
                   .edgesIgnoringSafeArea(.all)

               ZStack {
                   // Varias ondas concéntricas
                   ForEach(0..<5) { i in
                       Circle()
                           .stroke(Color.green.opacity(0.5), lineWidth: 3)
                           .frame(width: CGFloat(100 + i*40), height: CGFloat(100 + i*40))
                           .scaleEffect(animate ? 1.2 : 0.8)
                           .opacity(animate ? 0 : 1)
                           .animation(
                               Animation.easeOut(duration: 1.5)
                                   .repeatForever()
                                   .delay(Double(i) * 0.3),
                               value: animate
                           )
                   }

                   // Micrófono central
                   Circle()
                       .fill(Color.green)
                       .frame(width: 80, height: 80)
                       .overlay(
                           Image(systemName: "mic.fill")
                               .font(.system(size: 30))
                               .foregroundColor(.white)
                       )
               }
           }
           .onAppear {
               animate = true
           }
       }
}

#Preview {
    MicrophoneView()
}
