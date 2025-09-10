//
//  ContentView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Inicio", systemImage: "house.fill") {
                HomeView()
            }


            Tab("Cámara", systemImage: "camera.fill") {
                CameraView()
            }


            TabSection("Messages") {
                Tab("Alertas", systemImage: "bell.fill") {
                    AlertView()
                }


                Tab("Reportes", systemImage: "document.on.document.fill") {
                    AllReportsView()
                }


                Tab("Cuenta", systemImage: "person.crop.circle.fill") {
                    AccountView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
