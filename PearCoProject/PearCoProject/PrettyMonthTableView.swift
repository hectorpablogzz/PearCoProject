//
//  PrettyMonthTableView.swift
//  PearCoProject
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI

// Tabla bonita para mostrar el detalle del mes actual:
/// - Título con mes y región
/// - 4 filas (Roya, Broca, Ojo de gallo, Antracnosis)
/// - Barra horizontal proporcional al índice
/// - Chips de categoría e incertidumbre
struct PrettyMonthTable: View {
    let monthName: String
    let regionName: String
    let items: [RiskItem]

    // Colorea por categoría: "Bajo", "Medio", "Alto"
    let categoryColor: (String) -> Color
    // Icono por enfermedad: "roya", "broca", "ojogallo", "antracnosis"
    let diseaseIcon: (String) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Detalle de \(monthName) — \(regionName)")
                    .font(.headline)
                Spacer()
            }

            LazyVStack(spacing: 10) {
                ForEach(items) { it in
                    PrettyRow(
                        item: it,
                        categoryColor: categoryColor,
                        diseaseIcon: diseaseIcon
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// Subvistas
private struct PrettyRow: View {
    let item: RiskItem
    let categoryColor: (String) -> Color
    let diseaseIcon: (String) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Encabezado de la fila
            HStack(spacing: 10) {
                Image(systemName: diseaseIcon(item.disease))
                    .foregroundStyle(categoryColor(item.category))

                Text(item.disease.capitalized)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                Chip(text: item.category, color: categoryColor(item.category))
                Chip(text: "\(Int(item.uncertainty * 100))% inc.", color: .secondary)
            }

            // Barra de progreso horizontal (índice 0..1)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.12))

                    RoundedRectangle(cornerRadius: 8)
                        .fill(categoryColor(item.category).opacity(0.75))
                        .frame(width: max(0, CGFloat(item.risk) * geo.size.width))
                }
            }
            .frame(height: 12)

            // Pie de fila
            HStack {
                Text("Índice: \(String(format: "%.2f", item.risk))")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if let d = item.drivers.first {
                    Text("• \(d)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct Chip: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}
