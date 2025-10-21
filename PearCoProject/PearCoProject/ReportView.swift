//
//  ReportView.swift
//  PearCoProject
//
//  Created by Héctor Pablo González on 09/09/25.

import SwiftUI
import Charts

struct ReportView: View {
  
    let report: Report
    
    var body: some View {
        ZStack {
            // Fondo
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(report.title)
                        .font(.system(size: 55, weight: .bold))
                        .foregroundColor(Color.verdeOscuro)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                        .padding()
                    Text(report.message)
                        .font(.system(size: 25, weight: .semibold))
                        .padding(30)
                    
                    // Gráficos
                    ChartSection(title: "% Riesgo de Roya", data: report.data.map { ($0.month, Double($0.royaRisk)) }, color: .red)
                    ChartSection(title: "% Riesgo de Broca", data: report.data.map { ($0.month, Double($0.brocaRisk)) }, color: .red)
                    ChartSection(title: "% Riesgo de Ojo de Gallo", data: report.data.map { ($0.month, Double($0.ojoRisk)) }, color: .red)
                    ChartSection(title: "% Riesgo de Antracnosis", data: report.data.map { ($0.month, Double($0.antracRisk)) }, color: .red)
                    ChartSection(title: "Temperatura promedio (°C)", data: report.data.map { ($0.month, Double($0.temperature)) }, color: .blue)
                    ChartSection(title: "Lluvia total al mes (mm)", data: report.data.map { ($0.month, Double($0.rain)) }, color: .blue)
                    
                    Spacer().frame(height: 150) // espacio inferior para el botón
                }
            }
            
            // 🔹 Botón flotante del micrófono
            MicrophoneButton(color: Color.verdeOscuro)
        }
    }
}

// Reutilizamos sección de gráfico
struct ChartSection: View {
    let title: String
    let data: [(String, Double)]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .bold()
                .foregroundColor(.verdeOscuro)
                .padding(.horizontal)
            
            Chart {
                ForEach(data, id: \.0) { (label, value) in
                    LineMark(x: .value("Mes", label),
                             y: .value("Valor", value))
                        .foregroundStyle(color)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
    }
}


#Preview {
    ReportView(report: Report(title: "Junio 2025", message: "Este mes hubo un aumento drástico en el riesgo del desarrollo de plagas y enfermedades debido al alto volumen de lluvia. El riesgo de roya subió a 90% y el riesgo de broca a 70%.", data: [
        .init(year: 2025, month: "Jan", temperature: 16.338, rain: 33.8, royaRisk: 10, brocaRisk: 15, ojoRisk: 51, antracRisk: 52),
        .init(year: 2025, month: "Feb", temperature: 18.107, rain: 57.4, royaRisk: 20, brocaRisk: 30, ojoRisk: 27, antracRisk: 85),
        .init(year: 2025, month: "Mar", temperature: 19.072, rain: 25.4, royaRisk: 15, brocaRisk: 20, ojoRisk: 52, antracRisk: 28),
        .init(year: 2025, month: "Apr", temperature: 21.133, rain: 50, royaRisk: 35, brocaRisk: 40, ojoRisk: 16, antracRisk: 77),
        .init(year: 2025, month: "May", temperature: 23.538, rain: 78.8, royaRisk: 50, brocaRisk: 60, ojoRisk: 9, antracRisk: 88),
        .init(year: 2025, month: "Jun", temperature: 22.883, rain: 179.8, royaRisk: 90, brocaRisk: 70, ojoRisk: 77, antracRisk: 63)
    ]))
}

               
                
                

