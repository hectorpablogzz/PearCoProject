//
//  RiskHeatmapView.swift
//  PearCoProject
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI

struct RiskHeatmapView: View {
    let data: [RiskMonthResponse]
    @State private var showDetail: RiskItem?

    private let diseases = ["roya","broca","ojogallo","antracnosis"]
    private let monthAbbr = ["E","F","M","A","M","J","J","A","S","O","N","D"]

    func color(for category: String) -> Color {
        switch category.lowercased() {
        case "alto": return .red.opacity(0.75)
        case "medio": return .orange.opacity(0.75)
        default: return .green.opacity(0.75)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Cabecera
            HStack {
                Text("Enfermedad").font(.subheadline).frame(width: 120, alignment: .leading)
                ForEach(0..<12, id: \.self) { i in
                    Text(monthAbbr[i]).font(.caption).frame(maxWidth: .infinity)
                }
            }
            // Filas
            ForEach(diseases, id: \.self) { dis in
                HStack(spacing: 6) {
                    Text(dis.capitalized).frame(width: 120, alignment: .leading)
                    ForEach(1...12, id: \.self) { m in
                        let item = data[m-1].results.first { $0.disease == dis }
                        Button {
                            if let it = item { showDetail = it }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(color(for: item?.category ?? "bajo"))
                                    .frame(height: 28)
                                if let u = item?.uncertainty, u > 0.4 {
                                    Text("⚠︎").font(.caption2).foregroundStyle(.white)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            Text("Colores: Bajo/Medio/Alto • ⚠︎ = alta incertidumbre")
                .font(.footnote).foregroundStyle(.secondary)
        }
        .sheet(item: $showDetail) { it in
            VStack(spacing: 12) {
                Text(it.disease.capitalized).font(.headline)
                Text("Riesgo: \(String(format: "%.2f", it.risk)) • \(it.category)")
                Text("Incertidumbre: \(String(format: "%.0f%%", it.uncertainty*100))")
                    .foregroundStyle(.secondary)
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    Text("Factores").font(.subheadline)
                    ForEach(it.drivers, id: \.self) { d in Text("• \(d)") }
                }
                Spacer()
            }
            .padding()
            .presentationDetents([.fraction(0.35), .medium])
        }
    }
}
