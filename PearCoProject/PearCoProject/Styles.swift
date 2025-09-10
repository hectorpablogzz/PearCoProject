//
//  Styles.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

// Estructura global para los estilos
struct AppStyle {
    // Colores globales
    static let backgroundColor = Color(white: 0.98)  // Beige claro
    static let cardBackgroundColor = Color.white
    static let borderColor = Color.gray.opacity(0.2)
    static let tabBackgroundColor = Color.gray.opacity(0.1)
    static let accentColor = Color.green

    // CardView reutilizable
    struct CardView<Content: View>: View {
        var content: Content

        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }

        var body: some View {
            VStack {
                content
            }
            .padding()
            .background(AppStyle.cardBackgroundColor)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 4)  // Sombra corregida aquí
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(AppStyle.borderColor, lineWidth: 1))
        }
    }
}
