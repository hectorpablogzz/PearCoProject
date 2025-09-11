//
//  Styles.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

extension Color {
   // static let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255)
    static let beige = Color(hex: "#FFFFF5") // Fondo beige
    //static let verdeBoton = Color(hex: "#269260")
    static let verdeBoton = Color(hex: "#269260")
}



// Modificador para la franja verde lateral
struct GreenSidebarModifier: ViewModifier {
    let sidebarWidth: CGFloat = 75
    let sidebarColor = Color.verdeOscuro

    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            // Franja verde
            sidebarColor
                .frame(width: sidebarWidth)
            
            // Contenido principal
            content
                .background(Color(hex: "#FFFFF5").edgesIgnoringSafeArea(.all))
        }
    }
}

extension View {
    func greenSidebar() -> some View {
        self.modifier(GreenSidebarModifier())
    }
}



// Modificador para los títulos en verde
struct GreenTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .foregroundColor(Color(hex: "#263C32"))
    }
}

extension View {
    func greenTitle() -> some View {
        self.modifier(GreenTitle())
    }
}


// Extensión para convertir HEX a Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var hexColor: UInt64 = 0
        scanner.scanHexInt64(&hexColor)
        self.init(
            red: Double((hexColor & 0xFF0000) >> 16) / 255,
            green: Double((hexColor & 0x00FF00) >> 8) / 255,
            blue: Double(hexColor & 0x0000FF) / 255
        )
    }
}
