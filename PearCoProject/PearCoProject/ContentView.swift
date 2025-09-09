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


                Tab("Historial", systemImage: "clock.fill") {
                    RecordsView()
                }


                Tab("Cuenta", systemImage: "person.crop.circle.fill") {
                    AccountView()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
