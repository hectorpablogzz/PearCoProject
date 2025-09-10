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
        NavigationStack{
            List {
                
                Text("IMPORTANTE: Los reportes contienen recomendaciones basadas en algoritmos que pueden equivocarse. Antes de tomar decisiones importantes, es indispensable consultar con su técnico asignado.")
                    .font(.caption)
                ForEach(VM.reports) { item in
                    NavigationLink {
                        ReportView(report: item)
                    } label: {
                        Text(item.title)
                    }
                }
            }
            //.scrollContentBackground(.hidden)
            .navigationTitle("Reportes")
        }
    }
}

#Preview {
    AllReportsView()
}
