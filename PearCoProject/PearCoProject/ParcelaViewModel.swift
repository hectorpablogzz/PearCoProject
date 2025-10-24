
//
//  ParcelaViewModel.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//

import Foundation

@MainActor
class ParcelaViewModel: ObservableObject {
    @Published var parcelas: [Parcela] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Propiedad para saber si hay error y mostrarlo
    var hasError: Bool {
        errorMessage != nil
    }
    
    // --- CORRECCIÓN AQUÍ ---
    // Cambia esta IP por la de tu computadora si es distinta
    private let baseURL = "http://10.22.215.30:5050/parcelas"
    
    // Obtener todas las parcelas
    func fetchParcelas() async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: baseURL) else {
            errorMessage = "URL inválida"
            isLoading = false
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                errorMessage = "Respuesta inválida del servidor"
                isLoading = false
                return
            }
            
            // --- CORRECCIÓN AQUÍ ---
            // Decodificar usando el struct 'ParcelaListResponse' que envuelve la lista
            let decodedResponse = try JSONDecoder().decode(ParcelaListResponse.self, from: data)
            
            if decodedResponse.success {
                self.parcelas = decodedResponse.data
            } else {
                errorMessage = decodedResponse.error ?? "Error desconocido al obtener parcelas"
            }
            isLoading = false
        } catch {
            print("❌ Error al cargar parcelas: \(error)")
            self.errorMessage = "Error de conexión: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    // Crear nueva parcela
    func createParcela(nombre: String, hectareas: Double, tipo: String,
                       estado: String, municipio: String, latitud: Double, longitud: Double) async {
        errorMessage = nil
        guard let url = URL(string: baseURL) else { return }
        
        let nuevaParcela: [String: Any] = [
            "nombre": nombre,
            "hectareas": hectareas,
            "tipo": tipo,
            "ubicacion": [
                "estado": estado,
                "municipio": municipio,
                "latitud": latitud,
                "longitud": longitud
            ]
        ]
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: nuevaParcela)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 201 else {
                errorMessage = "No se pudo crear la parcela (código de respuesta no 201)"
                return
            }
            
            // --- CORRECCIÓN AQUÍ ---
            // Decodificar usando 'ParcelaResponse' (un solo objeto)
            let decodedResponse = try JSONDecoder().decode(ParcelaResponse.self, from: data)
            if decodedResponse.success {
                self.parcelas.append(decodedResponse.data)
            } else {
                errorMessage = decodedResponse.error ?? "Error al crear la parcela"
            }
        } catch {
            print("❌ Error creando parcela: \(error)")
            errorMessage = "Error de conexión al crear: \(error.localizedDescription)"
        }
    }
    
    // Actualizar una parcela existente
    func updateParcela(id: String, nombre: String, hectareas: Double, tipo: String,
                       estado: String, municipio: String, latitud: Double, longitud: Double) async {
        errorMessage = nil
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        
        let datosActualizados: [String: Any] = [
            "nombre": nombre,
            "hectareas": hectareas,
            "tipo": tipo,
            "ubicacion": [
                "estado": estado,
                "municipio": municipio,
                "latitud": latitud,
                "longitud": longitud
            ]
        ]
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: datosActualizados)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                errorMessage = "No se pudo actualizar (código de respuesta no 200)"
                return
            }
            
            // --- CORRECCIÓN AQUÍ ---
            // Decodificar usando 'ParcelaResponse'
            let decodedResponse = try JSONDecoder().decode(ParcelaResponse.self, from: data)
            
            if decodedResponse.success {
                if let index = self.parcelas.firstIndex(where: { $0.idParcela == id }) {
                    self.parcelas[index] = decodedResponse.data
                }
            } else {
                errorMessage = decodedResponse.error ?? "Error al actualizar la parcela"
            }
        } catch {
            print("❌ Error actualizando parcela: \(error)")
            errorMessage = "Error de conexión al actualizar: \(error.localizedDescription)"
        }
    }
    
    // Eliminar una parcela
    func deleteParcela(id: String) async {
        errorMessage = nil
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                errorMessage = "Error, el servidor no pudo eliminar el recurso."
                return
            }
            
            parcelas.removeAll { $0.idParcela == id }
        } catch {
            print("❌ Error eliminando parcela: \(error)")
            errorMessage = "Error de conexión al eliminar: \(error.localizedDescription)"
        }
    }
}
