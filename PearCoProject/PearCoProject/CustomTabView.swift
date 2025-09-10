//
//  CustomTabView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct CustomTabView: View {
    var body: some View {
        TabView {
            Tab("Inicio", systemImage: "house.fill") {
                HomeView()
            }

            Tab("Cámara", systemImage: "camera.fill") {
                CameraView()
            }

            Tab("Mensajes", systemImage: "bell.fill") {
                AlertView()
            }

            Tab("Reportes", systemImage: "document.fill") {
                AllReportsView()
            }

            Tab("Cuenta", systemImage: "person.crop.circle.fill") {
                AccountView()
            }
        }
        .tabViewStyle(DefaultTabViewStyle()) // Asegura que la barra esté en la parte inferior
        .background(Color.gray.opacity(0.2)
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}


#Preview {
    CustomTabView()
}
