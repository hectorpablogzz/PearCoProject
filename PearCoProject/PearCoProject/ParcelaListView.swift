//
//  ParcelaListView.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI

struct ParcelaListView: View {
    // Crea y gestiona su propia instancia de ViewModel
    @StateObject private var viewModel = ParcelaViewModel()
    // Estado para mostrar/ocultar el formulario modal
    @State private var showForm = false

    var body: some View {
        // NavigationStack es crucial para NavigationLink y títulos
        // Si esta vista YA está dentro de un NavigationStack (p.ej., desde ContentView o AccountView),
        // puedes quitar este NavigationStack externo, pero asegúrate de que esté en uno superior.
        // NavigationStack { // Descomenta si esta es la vista raíz para parcelas
            VStack {
                // Título principal (ajusta estilo si es necesario)
                Text("Mis Parcelas")
                    //.font(.largeTitle.weight(.bold)) // Estilo alternativo
                    .font(.system(size: 35, weight: .bold)) // Tamaño consistente
                    .foregroundColor(Color.verdeTitulos) // Usando tu color de Styles.swift
                    .padding(.top, 15)
                    .padding(.bottom, 5)

                // Contenido condicional: Cargando, Error, Vacío o Lista
                if viewModel.isLoading {
                    ProgressView("Cargando parcelas...")
                        .padding()
                } else if viewModel.hasError {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .font(.largeTitle)
                            .padding(.bottom, 5)
                        Text("Error al cargar parcelas.")
                            .foregroundColor(.red)
                        Text(viewModel.errorMessage ?? "Intenta de nuevo más tarde.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Reintentar") {
                            Task { await viewModel.fetchParcelas() }
                        }
                        .buttonStyle(.bordered)
                        .padding(.top)
                    }
                } else if viewModel.parcelas.isEmpty {
                    VStack {
                         Image(systemName: "leaf.fill")
                             .font(.largeTitle)
                             .foregroundColor(.gray)
                             .padding(.bottom, 10)
                         Text("No hay parcelas registradas")
                             .foregroundColor(.secondary)
                         Button {
                             showForm = true // Botón para añadir la primera
                         } label: {
                             Label("Añadir Parcela", systemImage: "plus.circle.fill")
                         }
                         .buttonStyle(.borderedProminent)
                         .padding(.top)
                    }
                    .padding()

                } else {
                    // --- La Lista de Parcelas ---
                    List {
                        ForEach(viewModel.parcelas) { parcela in
                            // NavigationLink para ir al detalle
                            NavigationLink {
                                // Destino: ParcelaDetailView
                                ParcelaDetailView(parcela: parcela, viewModel: viewModel)
                            } label: {
                                // Contenido de cada fila
                                HStack {
                                    Image(systemName: "mappin.and.ellipse") // Icono
                                        .foregroundColor(Color.verdeOscuro)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(parcela.nombre).font(.headline)
                                        Text("Cultivo: \(parcela.tipo)").font(.subheadline).foregroundColor(.gray)
                                        // Formateo correcto para Double
                                        Text("Hectáreas: \(String(format: "%.2f", parcela.hectareas)) ha").font(.caption).foregroundColor(.secondary)
                                        Text("\(parcela.ubicacion.municipio), \(parcela.ubicacion.estado)").font(.caption2).foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 8) // Espaciado vertical en la fila
                            }
                        }
                        .onDelete { indexSet in
                            // Lógica para eliminar (usa el ID String)
                            Task {
                                for index in indexSet {
                                    // Asegúrate que el índice es válido
                                    guard index < viewModel.parcelas.count else { continue }
                                    let idToDelete = viewModel.parcelas[index].idParcela // id es String
                                    await viewModel.deleteParcela(id: idToDelete)
                                }
                                // Opcional: Recargar si hubo error en delete
                                if viewModel.hasError {
                                     await viewModel.fetchParcelas()
                                }
                            }
                        }
                    } // Fin List
                    .listStyle(.insetGrouped) // Estilo de lista moderno
                    // Opcional: Añade un refresh control
                     .refreshable {
                         await viewModel.fetchParcelas()
                     }
                }
            } // Fin VStack principal
            // .padding() // Decide si necesitas padding general aquí o no
            .task {
                // Carga inicial al aparecer la vista
                // Evita recargar si ya hay parcelas (a menos que quieras forzar)
                if viewModel.parcelas.isEmpty {
                    await viewModel.fetchParcelas()
                }
            }
            .toolbar {
                // Botón "+" en la barra de navegación para añadir
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showForm = true // Abre el formulario modal
                    } label: {
                        Label("Añadir Parcela", systemImage: "plus.circle.fill")
                            .font(.title2) // Tamaño del icono
                            .foregroundColor(Color.verdeBoton) // Usa tu color
                    }
                }
                 // Opcional: Botón Editar para habilitar modo de eliminación
                 // ToolbarItem(placement: .navigationBarLeading) { EditButton() }
            }
            // Hoja modal para presentar el formulario de creación/edición
            .sheet(isPresented: $showForm) {
                // El formulario necesita su propio NavigationStack para tener barra de título y botones
                NavigationStack {
                    // Pasa el ViewModel para que el form pueda llamar a create/update
                    ParcelaFormView(viewModel: viewModel)
                }
            }
            // Título que aparece en la barra de navegación
             .navigationTitle("Mis Parcelas") // Redundante si ya tienes el Text arriba, elige uno
             .navigationBarTitleDisplayMode(.inline) // Título pequeño en la barra

        // } // Fin NavigationStack (si lo quitaste al inicio)
    }
}

// Preview Provider
struct ParcelaListView_Previews: PreviewProvider {
    static var previews: some View {
        // Envuelve en NavigationStack para que el preview funcione bien
        NavigationStack {
            ParcelaListView()
            // Puedes inyectar un ViewModel con datos de prueba si quieres
            // .environmentObject(ParcelaViewModel.previewWithData())
        }
    }
}
