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
            Tab("Inicio", systemImage: "house") {
                HomeView()
            }


            Tab("Cámara", systemImage: "camera") {
                CameraView()
            }


            TabSection("Messages") {
                Tab("Alertas", systemImage: "bell") {
                    AlertView()
                }


                Tab("Historial", systemImage: "clock") {
                    RecordsView()
                }


                Tab("Cuenta", systemImage: "person.crop.circle.fill") {
                    AccountView()
                }
            }
        }
        .background(Color.gray.opacity(0.2)
            .cornerRadius(10)
            .shadow(radius: 5)
        )
        .accentColor(.green)
        .padding(.top, 10)
        .edgesIgnoringSafeArea(.bottom)
    }
}



#Preview {
    ContentView()
}
