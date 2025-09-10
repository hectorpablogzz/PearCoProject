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


            //Tab("Historial", systemImage: "clock") {
                //ReportView(report: <#Report#>)
            //}


            Tab("Cuenta", systemImage: "person.crop.circle.fill") {
                    AccountView()
                }
            }
            .background(Color.gray.opacity(0.2)
                .cornerRadius(10)
                .shadow(radius: 5)
            )
    }
}

#Preview {
    CustomTabView()
}
