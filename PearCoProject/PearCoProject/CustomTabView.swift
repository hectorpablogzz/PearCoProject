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
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Inicio")
            }

<<<<<<< Updated upstream
            Tab("Cámara", systemImage: "camera.fill") {
=======
            NavigationStack {
>>>>>>> Stashed changes
                CameraView()
            }
            .tabItem {
                Image(systemName: "camera.fill")
                Text("Cámara")
            }

<<<<<<< Updated upstream
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
=======
            NavigationStack {
                AlertView()
            }
            .tabItem {
                Image(systemName: "bell.fill")
                Text("Mensajes")
            }

            NavigationStack {
                AllReportsView()
            }
            .tabItem {
                Image(systemName: "document.fill")
                Text("Reportes")
            }

            NavigationStack {
                AccountView()
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Cuenta")
            }

            NavigationStack {
                FarmersView()
            }
            .tabItem {
                Image(systemName: "person.2.fill")
                Text("Personas")
            }
        }
        .background(
            Color.gray.opacity(0.2)
                .cornerRadius(10)
                .shadow(radius: 5)
>>>>>>> Stashed changes
        )
    }
}


#Preview {
    CustomTabView()
}

