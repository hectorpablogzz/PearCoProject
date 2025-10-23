//
//  ParcelaDetailView.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//


import SwiftUI

struct ParcelaDetailView: View {
    let parcela: Parcela
    
    // 1. Recibe el ViewModel para poder pasarlo a la vista de edición
    @ObservedObject var viewModel: ParcelaViewModel
    
    @State private var showEditForm = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text(parcela.nombre)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
                
                Divider()
                
                InfoRow(label: "Tipo de Cultivo", value: parcela.tipo)
                
                // --- LÍNEA CORREGIDA ---
                InfoRow(label: "Hectáreas", value: "\(String(format: "%.2f", parcela.hectareas)) ha")
                // --- FIN DE LA CORRECCIÓN ---
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ubicación")
                        .font(.system(size: 22, weight: .semibold))
                    
                    InfoRow(label: "Estado", value: parcela.ubicacion.estado)
                    InfoRow(label: "Municipio", value: parcela.ubicacion.municipio)
                    InfoRow(label: "Latitud", value: "\(parcela.ubicacion.latitud)")
                    InfoRow(label: "Longitud", value: "\(parcela.ubicacion.longitud)")
                }
                .padding()
                .background(Color.grisFondo) // Color de Styles.swift
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Detalle de Parcela")
        .navigationBarTitleDisplayMode(.inline)
        // 2. Botón de Editar en la barra de navegación
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Editar") {
                    showEditForm = true
                }
                .foregroundColor(Color.verdeBoton)
            }
        }
        // 3. Hoja modal para presentar el formulario de edición
        .sheet(isPresented: $showEditForm) {
            NavigationStack {
                ParcelaFormView(viewModel: viewModel, parcela: parcela)
            }
        }
    }
}

// Pequeña vista auxiliar para un diseño consistente
struct InfoRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}