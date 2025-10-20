//
//  PrettyMonthTableView.swift
//  PearCoProject
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI

private func diseaseIcon(_ d: String) -> String {
    switch d.lowercased() {
    case "roya":        return "leaf.fill"
    case "broca":       return "ant.fill"
    case "ojogallo":    return "eye.circle.fill"
    case "antracnosis": return "bolt.heart.fill"
    default:            return "exclamationmark.triangle.fill"
    }
}

private func categoryColor(_ cat: String) -> Color {
    switch cat.lowercased() {
    case "alto":  return .red
    case "medio": return .orange
    default:      return .green
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

private struct PrettyRow: View {
    let item: RiskItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: diseaseIcon(item.disease))
                    .foregroundStyle(categoryColor(item.category))
                Text(item.disease.capitalized)
                    .font(.subheadline).fontWeight(.semibold)
                Spacer()
                Chip(text: item.category, color: categoryColor(item.category))
                Chip(text: "\(Int(item.uncertainty * 100))% inc.", color: .secondary)
            }
            // progress bar horizontal
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

struct PrettyMonthTableView: View {
    let monthName: String
    let regionName: String
    let items: [RiskItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Detalle de \(monthName) — \(regionName)")
                    .font(.headline)
                Spacer()
            }
            LazyVStack(spacing: 10) {
                ForEach(items) { it in
                    PrettyRow(item: it)
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
