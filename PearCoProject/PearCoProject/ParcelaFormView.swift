//
//  ParcelaFormView.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI
internal import Combine // Para filtrar entrada numérica

struct ParcelaFormView: View {
    // Recibe el ViewModel de la vista anterior (Observa cambios)
    @ObservedObject var viewModel: ParcelaViewModel

    // Parcela opcional: si no es nil, estamos en modo Edición
    var parcela: Parcela? // Usa el Parcela struct global (con ID String)

    // Estados locales para los campos del formulario
    @State private var nombre = ""
    @State private var hectareas = ""
    @State private var tipo = ""
    @State private var estado = ""
    @State private var municipio = ""
    @State private var latitud = ""
    @State private var longitud = ""

    // Para cerrar la vista modal
    @Environment(\.dismiss) var dismiss

    // Para mostrar alertas de error si falla la creación/actualización
    @State private var showingAlert = false
    @State private var alertMessage = ""

    // Validación simple: ¿Están todos los campos llenos?
    private var isFormValid: Bool {
        !nombre.isEmpty && !hectareas.isEmpty && !tipo.isEmpty &&
        !estado.isEmpty && !municipio.isEmpty && !latitud.isEmpty && !longitud.isEmpty &&
        // Verifica que los campos numéricos sean realmente números válidos
        Double(hectareas) != nil && Double(latitud) != nil && Double(longitud) != nil
    }

    // Formateador para campos numéricos (opcional, mejora UX)
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6 // Ajusta precisión según necesites
        return formatter
    }()

    var body: some View {
        // Form agrupa las secciones
        Form {
            // --- Sección Datos Parcela ---
            Section("Datos de la Parcela") { // Usar String directamente como header
                TextField("Nombre de la parcela", text: $nombre)
                TextField("Hectáreas", text: $hectareas)
                    .keyboardType(.decimalPad)
                    // Filtra para permitir solo números y un punto decimal
                    .onReceive(Just(hectareas)) { newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered.filter({ $0 == "." }).count <= 1 { // Permite solo un punto
                            if filtered != newValue {
                                self.hectareas = filtered
                            }
                        } else {
                            // Si hay más de un punto, revierte al valor anterior válido
                             self.hectareas = String(filtered.dropLast())
                        }
                    }
                TextField("Tipo de cultivo (Ej: Café Arábica)", text: $tipo)
            }

            // --- Sección Ubicación ---
            Section("Ubicación") {
                TextField("Estado", text: $estado)
                TextField("Municipio", text: $municipio)
                TextField("Latitud", text: $latitud)
                    .keyboardType(.decimalPad)
                     .onReceive(Just(latitud)) { filterNumericInput($0, binding: $latitud) } // Reusa filtro
                TextField("Longitud", text: $longitud)
                    .keyboardType(.decimalPad)
                     .onReceive(Just(longitud)) { filterNumericInput($0, binding: $longitud) } // Reusa filtro
            }

            // --- Sección Botón Guardar/Actualizar ---
            Section {
                Button {
                    // Llama a la función de guardado/actualización
                    Task { await saveOrUpdateParcela() }
                } label: {
                    Text(parcela == nil ? "Guardar Nueva Parcela" : "Actualizar Parcela")
                        .bold()
                        .frame(maxWidth: .infinity) // Ocupa todo el ancho
                }
                .buttonStyle(.borderedProminent) // Estilo de botón principal
                .tint(Color.verdeBoton) // Usa tu color de botón
                .disabled(!isFormValid) // Deshabilita si el formulario no es válido
            }
            // Quita los insets para que el botón toque los bordes (estilo común)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear) // Fondo transparente si es necesario

            // --- Mensaje de Ayuda si no es válido ---
            if !isFormValid {
                Section {
                    Text("Por favor, rellena todos los campos correctamente para guardar.")
                        .font(.caption)
                        .foregroundColor(.orange) // O .gray
                }
            }
        } // Fin Form
        .navigationTitle(parcela == nil ? "Nueva Parcela" : "Editar Parcela")
        .navigationBarTitleDisplayMode(.inline) // Título pequeño
        .toolbar {
            // Botón "Cancelar" en la barra de navegación
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancelar") {
                    dismiss() // Cierra la vista modal
                }
            }
        }
        .onAppear {
            // Si parcela no es nil, estamos editando, así que llena los campos
            if let p = parcela {
                nombre = p.nombre
                hectareas = String(p.hectareas) // Convierte Double a String
                tipo = p.tipo
                estado = p.ubicacion.estado
                municipio = p.ubicacion.municipio
                latitud = String(p.ubicacion.latitud) // Convierte Double a String
                longitud = String(p.ubicacion.longitud) // Convierte Double a String
            }
        }
        // Muestra alerta si hubo error al guardar/actualizar
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") {} // Botón simple para cerrar alerta
        } message: {
            Text(alertMessage) // Muestra el mensaje de error del ViewModel
        }
    }

    // --- Función Helper para Guardar/Actualizar ---
    private func saveOrUpdateParcela() async {
        // Convierte los Strings numéricos a Double de forma segura
        guard let h = Double(hectareas), let lat = Double(latitud), let lon = Double(longitud) else {
            alertMessage = "Los valores de hectáreas, latitud y longitud deben ser números válidos."
            showingAlert = true
            return
        }

        if let p = parcela {
            // --- Modo Edición ---
            // Llama a updateParcela con el ID String
            await viewModel.updateParcela(
                id: p.idParcela, // id es String
                nombre: nombre, hectareas: h, tipo: tipo,
                estado: estado, municipio: municipio, latitud: lat, longitud: lon
            )
        } else {
            // --- Modo Creación ---
            await viewModel.createParcela(
                nombre: nombre, hectareas: h, tipo: tipo,
                estado: estado, municipio: municipio, latitud: lat, longitud: lon
            )
        }

        // Verifica si hubo error después de la llamada al ViewModel
        if viewModel.hasError {
            alertMessage = viewModel.errorMessage ?? "Ocurrió un error desconocido."
            showingAlert = true
        } else {
            dismiss() // Cierra el formulario si no hubo error
        }
    }

     // --- Función Helper para Filtrar Input Numérico ---
     private func filterNumericInput(_ newValue: String, binding: Binding<String>) {
         // Permite números, un punto decimal y opcionalmente un signo negativo al inicio
         let filtered = newValue.filter { "-0123456789.".contains($0) }

         // Permite solo un punto decimal
         let decimalPointCount = filtered.filter { $0 == "." }.count
         // Permite solo un signo negativo y solo al inicio
         let minusSignCount = filtered.filter { $0 == "-" }.count
         let isMinusSignValid = minusSignCount == 0 || (minusSignCount == 1 && filtered.hasPrefix("-"))

         if decimalPointCount <= 1 && isMinusSignValid {
             if filtered != newValue {
                 binding.wrappedValue = filtered
             }
         } else {
             // Revierte si la entrada es inválida (múltiples puntos o signos negativos mal colocados)
             let current = binding.wrappedValue
             if !current.isEmpty { // Evita bucle infinito si el campo estaba vacío
                 binding.wrappedValue = String(current.dropLast())
             }
         }
     }
}

// Preview Provider
struct ParcelaFormView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview para Crear
        NavigationStack {
            ParcelaFormView(viewModel: ParcelaViewModel.previewWithData()) // Pasa un ViewModel
        }
        .previewDisplayName("Crear Parcela")

        // Preview para Editar
        let sampleParcela = Parcela(
            idParcela: "uuid-p1-edit", nombre: "Finca Vieja", hectareas: 12.5, tipo: "Café Caturra",
            ubicacion: Ubicacion(idUbicacion: "uuid-u1-edit", estado: "Oaxaca", municipio: "Pluma Hidalgo", latitud: 15.92, longitud: -96.40)
        )
        NavigationStack {
            ParcelaFormView(viewModel: ParcelaViewModel.previewWithData(), parcela: sampleParcela) // Pasa la parcela
        }
        .previewDisplayName("Editar Parcela")
    }
}
