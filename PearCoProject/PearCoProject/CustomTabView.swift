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

            NavigationStack {
                CameraView()
            }
            .tabItem {
                Image(systemName: "camera.fill")
                Text("Diagnóstico")
            }

            NavigationStack {
                AlertView()
            }
            .tabItem {
                Image(systemName: "bell.fill")
                Text("Alertas")
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
                Text("Personas") // Ahora siempre se muestra
            }
        }
        .background(
            Color.gray.opacity(0.2)
                .cornerRadius(10)
                .shadow(radius: 5)
        )
    }
}

#Preview {
    CustomTabView()
}
