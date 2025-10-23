//
//  ParcelaListView.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//


import SwiftUI

struct ParcelaListView: View {
    @StateObject private var viewModel = ParcelaViewModel()
    @State private var showForm = false
    
    var body: some View {
        // 1. Añadido NavigationStack para permitir la navegación
        NavigationStack {
            VStack {
                // 2. Título estilizado para coincidir con tu app
                Text("Parcelas Registradas")
                    .font(.system(size: 40, weight: .bold)) // Tamaño más consistente
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                if viewModel.isLoading {
                    ProgressView("Cargando parcelas...")
                        .padding()
                } else if viewModel.hasError {
                    Text("Error al cargar las parcelas.")
                        .foregroundColor(.red)
                } else if viewModel.parcelas.isEmpty {
                    Text("No hay parcelas registradas")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.parcelas) { parcela in
                            // 3. Cada fila es ahora un NavigationLink
                            NavigationLink(destination: ParcelaDetailView(parcela: parcela, viewModel: viewModel)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(parcela.nombre)
                                        .font(.headline)
                                    Text("Cultivo: \(parcela.tipo)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    // --- LÍNEA CORREGIDA ---
                                    Text("Hectáreas: \(String(format: "%.2f", parcela.hectareas))")
                                    // --- FIN DE LA CORRECCIÓN ---
                                    
                                        .font(.subheadline)
                                    Text("Ubicación: \(parcela.ubicacion.estado), \(parcela.ubicacion.municipio)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let id = viewModel.parcelas[index].idParcela
                                Task {
                                    await viewModel.deleteParcela(id: id)
                                }
                            }
                        }
                    }
                    .listStyle(.plain) // Estilo de lista más limpio
                }
            }
            .padding()
            .task {
                await viewModel.fetchParcelas()
            }
            // 4. Añadido Toolbar con botón para crear nueva parcela
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showForm = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color.verdeBoton) // Color de Styles.swift
                    }
                }
            }
            // 5. Hoja modal para presentar el formulario de creación
            .sheet(isPresented: $showForm) {
                NavigationStack {
                    ParcelaFormView(viewModel: viewModel)
                }
            }
            .navigationTitle("Mis Parcelas") // Título para la barra
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ParcelaListView()
}