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
            Tab("Inicio", systemImage: "paperplane") {
                HomeView()
            }


            Tab("Cámara", systemImage: "person.crop.circle.fill") {
                CameraView()
            }


            TabSection("Messages") {
                Tab("Alertas", systemImage: "tray.and.arrow.down.fill") {
                    AlertView()
                }


                Tab("Historial", systemImage: "tray.and.arrow.up.fill") {
                    RecordsView()
                }


                Tab("Cuenta", systemImage: "pencil") {
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
