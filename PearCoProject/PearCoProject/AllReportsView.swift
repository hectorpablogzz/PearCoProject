//
//  RecordsView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct AllReportsView: View {

    
    @State private var VM = AllReportsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                // Contenido principal
                HStack(spacing: 0) {
                    GeometryReader { geo in
                        ScrollView {
                            VStack(alignment: .leading, spacing: geo.size.height * 0.025) {
                                Text("Reportes")
                                    .font(.system(size: 55, weight: .bold))
                                    .foregroundColor(Color.verdeOscuro)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 20)
                                    .padding()
                                
                                
                                Text("IMPORTANTE: Los reportes contienen recomendaciones basadas en algoritmos que pueden equivocarse. Antes de tomar decisiones importantes, es indispensable consultar con su técnico asignado.")
                                    .font(.system(size: geo.size.width * 0.03, weight: .semibold))
                                    .padding(30)
                                
                                if(VM.isLoading) {
                                    VStack {
                                        Text("Cargando...")
                                        ProgressView()
                                    }
                                    .padding(30)
                                }
                                
                                if(VM.hasError) {
                                    Text("Error cargando reportes.")
                                        .foregroundStyle(Color.red)
                                        .padding(30)
                                }
                                
                                ForEach(VM.reports) { item in
                                    NavigationLink {
                                        ReportView(report: item)
                                    } label: {
                                        ReportCard(title: item.title, description: item.message, geo: geo)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                MicrophoneButton(color: Color.verdeOscuro)
            }
            
        
            
        }
        
    }
}

struct ReportCard: View {
    @State private var isCompleted = false
    let title: String
    let description: String
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.system(size: geo.size.width * 0.04))
                    .padding(.trailing, geo.size.width * 0.03)
                    .padding(.top, geo.size.height * 0.01)
            }
            
            HStack(spacing: geo.size.width * 0.02) {
                Image("report")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.18, height: geo.size.width * 0.18)
                    .cornerRadius(geo.size.width * 0.03)
                
                VStack(alignment: .leading, spacing: geo.size.height * 0.01) {
                    Text(title)
                        .font(.system(size: geo.size.width * 0.03, weight: .bold))
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.system(size: geo.size.width * 0.03))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
                
                Spacer()
                

            }
            .padding(.horizontal, geo.size.width * 0.03)
            .padding(.bottom, geo.size.height * 0.02)
        }
        .background(Color(.systemBackground))
        .cornerRadius(geo.size.width * 0.05)
        .shadow(color: .black.opacity(0.15), radius: geo.size.width * 0.02, x: 0, y: geo.size.height * 0.005)
        .padding(geo.size.width * 0.02)
    }
}

#Preview {
    AllReportsView()
}
