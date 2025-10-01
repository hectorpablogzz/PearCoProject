//
//  AlertView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct AlertView: View {
    @StateObject private var VM = AlertViewModel()
    @State private var selectedDate: Date = Date()
    
    var visibleDays: [Date] {
        let calendar = Calendar.current
        return (-6...6).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: Date())
        }
    }
    
    var groupedByDate: [Alert] {
        VM.alerts.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    var groupedByCategory: [String: [Alert]] {
        Dictionary(grouping: groupedByDate, by: { $0.category })
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(visibleDays, id: \.self) { day in
                            let isSelected = Calendar.current.isDate(day, inSameDayAs: selectedDate)
                            VStack {
                                Text(day, format: .dateTime.weekday(.abbreviated))
                                    .font(.caption)
                                Text(day, format: .dateTime.day())
                                    .font(.headline)
                            }
                            .padding(8)
                            .background(isSelected ? Color.green.opacity(0.7) : Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .onTapGesture { selectedDate = day }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 4)
                
                if VM.isLoading {
                    VStack {
                        Text("Cargando alertas...")
                        ProgressView()
                    }
                    .padding()
                }
                
                if VM.hasError {
                    Text("Error cargando alertas")
                        .foregroundColor(.red)
                        .padding()
                }
                
                List {
                    ForEach(groupedByCategory.keys.sorted(), id: \.self) { category in
                        Section(header: Text(category)) {
                            ForEach(groupedByCategory[category] ?? []) { alert in
                                AlertRow(alertObject: alert)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alertas")
        }
    }
}

struct AlertRow: View {
    @State private var isCompleted = false
    @State private var showDatePicker = false
    @State private var newDate: Date = Date()
    
    let alertObject: Alert
    
    var buttonColor: Color {
        alertObject.category == "Enfermedades" ? .red : Color(red: 59/255, green: 150/255, blue: 108/255)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    newDate = alertObject.date
                    showDatePicker = true
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16))
                        .padding(.trailing, 12)
                        .padding(.top, 4)
                }
                .sheet(isPresented: $showDatePicker) {
                    VStack(spacing: 20) {
                        DatePicker("Cambiar fecha", selection: $newDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .padding()
                        
                        Button("Guardar") {
                            alertObject.date = newDate
                            showDatePicker = false
                        }
                        .padding()
                    }
                    .presentationDetents([.medium])
                }
            }
            
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(alertObject.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(alertObject.action)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(isCompleted ? "Listo" : "Completar")
                    .font(.subheadline)
                    .foregroundColor(isCompleted ? .gray : .white)
                    .padding(8)
                    .background(isCompleted ? Color(.white) : buttonColor)
                    .cornerRadius(8)
                    .onTapGesture { isCompleted.toggle() }
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

#Preview{
    AlertView()
}
