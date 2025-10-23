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
    @Published var hasError: Bool = false
    
    private let baseURL = "http://10.22.215.30:5050/parcelas"
    
    func fetchParcelas() async {
        isLoading = true
        hasError = false
        guard let url = URL(string: baseURL) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                hasError = true
                isLoading = false
                return
            }
            let decoded = try JSONDecoder().decode([Parcela].self, from: data)
            self.parcelas = decoded
            isLoading = false
        } catch {
            print("❌ Error al cargar parcelas: \(error)")
            self.hasError = true
            self.isLoading = false
        }
    }
    
    func createParcela(nombre: String, hectareas: Double, tipo: String,
                       estado: String, municipio: String, latitud: Double, longitud: Double) async {
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
            guard (response as? HTTPURLResponse)?.statusCode == 201 else { return }
            
            let decoded = try JSONDecoder().decode(Parcela.self, from: data)
            self.parcelas.append(decoded)
        } catch {
            print("❌ Error creando parcela: \(error)")
        }
    }
    
    func updateParcela(id: Int, nombre: String, hectareas: Double, tipo: String,
                       estado: String, municipio: String, latitud: Double, longitud: Double) async {
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
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            let decoded = try JSONDecoder().decode(Parcela.self, from: data)
            if let index = self.parcelas.firstIndex(where: { $0.idParcela == id }) {
                self.parcelas[index] = decoded
            }
        } catch {
            print("❌ Error actualizando parcela: \(error)")
        }
    }
    
    func deleteParcela(id: Int) async {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            parcelas.removeAll { $0.idParcela == id }
        } catch {
            print("❌ Error eliminando parcela: \(error)")
        }
    }
}
