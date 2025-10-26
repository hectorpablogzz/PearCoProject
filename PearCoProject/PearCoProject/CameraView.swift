//
//  CameraView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

//Version 2 reto
import SwiftUI

struct CameraView: View {
   
   @State private var isPhotoTaken = false
   @State private var goToScan = false
   
   
   var body: some View {
       
       
       NavigationStack {
           ZStack {
               HStack(spacing: 0) {
                   ZStack {
                       
                       Color(UIColor.systemBackground)
                           .edgesIgnoringSafeArea(.all)
                       
                       HStack(spacing: 0) {
                           
                           
                           // Contenido principal
                           ScrollView {
                               VStack(spacing: 30) {
                                   
                                   // Título
                                   Text("Diagnóstico por Foto")
                                       .font(.system(size: 50, weight: .bold))
                                       .foregroundColor(Color.verdeTitulos)
                                       .frame(maxWidth: .infinity, alignment: .leading)
                                   
                                   Text("Centre la planta en la cámara para continuar")
                                       .font(.title2)
                                       .foregroundColor(.black)
                                       .frame(maxWidth: .infinity, alignment: .leading)
                                   
                                   // Imagen y botón de cámara
                                   ZStack {
                                       Image("CoffeePlant")
                                           .resizable()
                                           .aspectRatio(contentMode: .fill)
                                           .frame(width: 650, height: 700)
                                           .clipped()
                                           .cornerRadius(45)
                                           .overlay(
                                               RoundedRectangle(cornerRadius: 45)
                                                   .stroke(.black, lineWidth: 4)
                                           )
                                           .shadow(color: .black.opacity(0.4), radius: 50, x: 5, y: 5)
                                           .overlay(Color.white.opacity(isPhotoTaken ? 0.7 : 0)
                                               .cornerRadius(45)
                                           )
                                           .animation(.easeInOut(duration: 0.3), value: isPhotoTaken)
                                       
                                       Button {
                                           withAnimation { isPhotoTaken = true }
                                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                               withAnimation { isPhotoTaken = false }
                                               // Unificar: este mismo botón navega al escaneo
                                               goToScan = true
                                           }
                                       } label: {
                                           Image(systemName: "camera")
                                               .font(.system(size: 40))
                                               .foregroundColor(.white)
                                               .padding(30)
                                               .background(Color.black.opacity(0.3))
                                               .clipShape(Circle())
                                       }
                                   }
                                   
                                   let currentUserId = "18d7bd5e-d046-4e4f-9ef3-fe4c8a7877c7" // UUID de prueba

                                   // Botón “Escanear” (también navega)
                                   NavigationLink(destination: CameraScanView(userId: currentUserId), isActive: $goToScan) {
                                       Text("Escanear")
                                           .font(.title)
                                           .foregroundColor(.white)
                                           .font(Font.varButtonLabel)
                                           .padding()
                                           .frame(width: 300.0, height: 50.0)
                                           .background(Color.verdeBoton)
                                           .cornerRadius(20)
                                   }

                                   



                                   Spacer().frame(height: 150)
                               }
                               .padding(50)
                           }
                       }
                       MicrophoneButton(color: Color.verdeOscuro)
                   }
               }
               .greenSidebar()
           }
           .navigationTitle("Diagnóstico")
           .navigationBarHidden(true)
       }
       .navigationViewStyle(StackNavigationViewStyle())
   }
}


#Preview {
    CameraView()
}


