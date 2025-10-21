//
//  AlertView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI
import SwiftData

struct AlertView: View {
    @Query private var alerts: [Alert]
    @Environment(\.modelContext) private var context
    
    @StateObject private var VM = AlertViewModel()
    @State private var selectedDate = Date()
    
    // Calendario dinámico
    var visibleDays: [Date] {
        let calendar = Calendar.current
        return (-6...6).compactMap { calendar.date(byAdding: .day, value: $0, to: Date()) }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Selector de días
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(visibleDays, id: \.self) { day in
                            let isSelected = Calendar.current.isDate(day, inSameDayAs: selectedDate)
                            VStack {
                                Text(day, format: .dateTime.weekday(.abbreviated)).font(.caption)
                                Text(day, format: .dateTime.day()).font(.headline)
                            }
                            .padding(8)
                            .background(isSelected ? Color.green.opacity(0.7) : Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedDate = day
                                VM.groupAlerts(for: day)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 4)
                
                // Manejor de errores
                if VM.isLoading {
                    ProgressView("Cargando alertas...").padding()
                } else if VM.hasError {
                    Text("Error cargando alertas").foregroundColor(.red).padding()
                } else if VM.groupedAlerts.isEmpty {
                    Spacer()
                    EmptyStateView()
                    Spacer()
                } else {
                    List {
                        ForEach(VM.groupedAlerts.keys.sorted(), id: \.self) { category in
                            Section(header: Text(category)) {
                                let alerts = VM.groupedAlerts[category] ?? []
                                
                                ForEach(alerts) { alert in
                                    AlertRow(alert: alert, VM: VM)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            if alert.isCompleted {
                                                Button(role: .destructive) {
                                                    Task { await VM.delete(alert: alert) }
                                                } label: {
                                                    Label("Eliminar", systemImage: "trash")
                                                }
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Alertas")
            .task { await VM.loadAPI(for: selectedDate) }
        }
    }
}

struct AlertRow: View {
    @ObservedObject var alert: Alert
    let VM: AlertViewModel
    
    var buttonColor: Color {
        alert.category.lowercased() == "enfermedades" ? .red : Color(red: 59/255, green: 150/255, blue: 108/255)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(alert.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(alert.action)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if alert.type.lowercased() != "recordatorio" {
                    Button(action: { Task { await VM.toggleCompletion(alert: alert) } }) {
                        Text(alert.isCompleted ? "Completado" : "Completar")
                            .font(.subheadline)
                            .foregroundColor(alert.isCompleted ? .gray : .white)
                            .padding(8)
                            .background(alert.isCompleted ? Color(.systemGray6) : buttonColor)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 6)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack() {
            Image(systemName: "leaf.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .foregroundStyle(.green, .white)
            
            Text("Nada por hacer hoy")
                .font(.title)
        }
    }
}

#Preview {
    AlertView()
}
