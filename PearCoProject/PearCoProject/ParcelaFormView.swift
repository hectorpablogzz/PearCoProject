//
//  ParcelaFormView.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//


import SwiftUI

struct ParcelaFormView: View {
    @ObservedObject var viewModel: ParcelaViewModel
    
    // Si parcela != nil → modo edición
    var parcela: Parcela?
    
    @State private var nombre = ""
    @State private var hectareas = ""
    @State private var tipo = ""
    @State private var estado = ""
    @State private var municipio = ""
    @State private var latitud = ""
    @State private var longitud = ""
    
    @Environment(\.dismiss) var dismiss
    
    // --- 1. VALIDACIÓN ---
    // Esta variable comprueba que todos los campos de texto tengan contenido.
    private var isFormValid: Bool {
        return !nombre.isEmpty &&
               !hectareas.isEmpty &&
               !tipo.isEmpty &&
               !estado.isEmpty &&
               !municipio.isEmpty &&
               !latitud.isEmpty &&
               !longitud.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Datos de la Parcela")) {
                TextField("Nombre", text: $nombre)
                TextField("Hectáreas", text: $hectareas)
                    .keyboardType(.decimalPad)
                TextField("Tipo de cultivo", text: $tipo)
            }
            
            Section(header: Text("Ubicación")) {
                TextField("Estado", text: $estado)
                TextField("Municipio", text: $municipio)
                TextField("Latitud", text: $latitud)
                    .keyboardType(.decimalPad)
                TextField("Longitud", text: $longitud)
                    .keyboardType(.decimalPad)
            }
            
            // --- 2. BOTÓN MODIFICADO ---
            Section {
                Button(action: {
                    // Esta lógica ya es correcta.
                    // Si 'parcela' es nil (modo "Crear"),
                    // se ejecuta el bloque 'else'
                    Task {
                        if let parcela = parcela {
                            // Editar
                            await viewModel.updateParcela(
                                id: parcela.idParcela,
                                nombre: nombre,
                                hectareas: Double(hectareas) ?? 0.0,
                                tipo: tipo,
                                estado: estado,
                                municipio: municipio,
                                latitud: Double(latitud) ?? 0.0,
                                longitud: Double(longitud) ?? 0.0
                            )
                        } else {
                            // Crear (Esto es lo que pediste)
                            await viewModel.createParcela(
                                nombre: nombre,
                                hectareas: Double(hectareas) ?? 0.0,
                                tipo: tipo,
                                estado: estado,
                                municipio: municipio,
                                latitud: Double(latitud) ?? 0.0,
                                longitud: Double(longitud) ?? 0.0
                            )
                        }
                        dismiss()
                    }
                }) {
                    Text(parcela == nil ? "Guardar Parcela" : "Actualizar Parcela")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        // Cambia el color si el formulario no es válido
                        .background(isFormValid ? Color.verdeBoton : Color.gray)
                        .cornerRadius(10)
                }
                .listRowInsets(EdgeInsets())
                // Deshabilita el botón si el formulario no es válido
                .disabled(!isFormValid)
            }
            
            // 3. Mensaje de ayuda (opcional, pero buena UX)
            if !isFormValid {
                Section {
                    Text("Por favor, rellene todos los campos para poder guardar.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle(parcela == nil ? "Nueva Parcela" : "Editar Parcela")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let parcela = parcela {
                nombre = parcela.nombre
                hectareas = "\(parcela.hectareas)"
                tipo = parcela.tipo
                estado = parcela.ubicacion.estado
                municipio = parcela.ubicacion.municipio
                latitud = "\(parcela.ubicacion.latitud)"
                longitud = "\(parcela.ubicacion.longitud)"
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancelar") {
                    dismiss()
                }
            }
        }
    }
}
