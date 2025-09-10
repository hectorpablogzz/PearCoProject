//
//  ReportView.swift
//  PearCoProject
//
//  Created by Héctor Pablo González on 09/09/25.
//

import SwiftUI
import Charts

struct ReportView: View {
    let report: Report
    var body: some View {
        ScrollView {
            Text(report.title)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text(report.message)
                .padding()
            
            
            
            Text("% Riesgo de Roya")
                .bold()
            Chart {
                ForEach(report.data) { item in
                    LineMark(x: .value("Mes", item.month),
                             y: .value("Riesgo", item.royaRisk))
                }
            }
            .frame(height: 200)
            .padding()
            .foregroundStyle(Color.red)
            .chartYScale(domain: 0...100)
            
            Text("% Riesgo de Broca")
                .bold()
            Chart {
                ForEach(report.data) { item in
                    LineMark(x: .value("Mes", item.month),
                             y: .value("Riesgo", item.brocaRisk))
                }
            }
            .frame(height: 200)
            .padding()
            .foregroundStyle(Color.red)
            .chartYScale(domain: 0...100)
            
            Text("Temperatura promedio (°C)")
                .bold()
            Chart {
                ForEach(report.data) { item in
                    LineMark(x: .value("Mes", item.month),
                             y: .value("Temperatura", item.temperature))
                }
            }
            .frame(height: 200)
            .padding()
            
            Text("Lluvia total al mes (mm)")
                .bold()
            Chart {
                ForEach(report.data) { item in
                    LineMark(x: .value("Mes", item.month),
                             y: .value("Lluvia", item.rain))
                }
            }
            .frame(height: 200)
            .padding()
            
            
            
            
            
            
        }
        .padding()
    }
}

#Preview {
    ReportView(report: Report(title: "Junio 2025", message: "Este mes hubo un aumento drástico en el riesgo del desarrollo de plagas y enfermedades debido al alto volumen de lluvia. El riesgo de roya subió a 90% y el riesgo de broca a 70%.", data: [
        .init(year: 2025, month: "Jan", temperature: 16.338, rain: 33.8, royaRisk: 10, brocaRisk: 15),
        .init(year: 2025, month: "Feb", temperature: 18.107, rain: 57.4, royaRisk: 20, brocaRisk: 30),
        .init(year: 2025, month: "Mar", temperature: 19.072, rain: 25.4, royaRisk: 15, brocaRisk: 20),
        .init(year: 2025, month: "Apr", temperature: 21.133, rain: 50, royaRisk: 35, brocaRisk: 40),
        .init(year: 2025, month: "May", temperature: 23.538, rain: 78.8, royaRisk: 50, brocaRisk: 60),
        .init(year: 2025, month: "Jun", temperature: 22.883, rain: 179.8, royaRisk: 90, brocaRisk: 70)
    ]))
}
