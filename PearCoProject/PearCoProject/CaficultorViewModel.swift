//
//  CaficultoresViewModel.swift
//  PearCoProject
//
//  Created by Héctor Pablo González on 05/10/25.
//

import Foundation

@MainActor
class CaficultorViewModel: ObservableObject {
    @Published var caficultores: [Caficultor] = []
    @Published var errorMessage: String?
    
    private let baseURL = "https://pearcoflaskapi.onrender.com"
    
    @Published var hasError = false
    

    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    func getCaficultores() async throws {
        // 1. URL
        guard let url = URL(string: "\(baseURL)/caficultores") else {
            self.hasError = true
            self.errorMessage = "URL inválida"
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            self.hasError = true
            self.errorMessage = "Error HTTP: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let results = try decoder.decode([Caficultor].self, from: data)

        self.caficultores = results
        self.hasError = false
        self.errorMessage = nil
    }
    
    // POST (Crear un nuevo caficultor)
    func addCaficultor(_ caficultor: Caficultor) async {
        guard let url = URL(string: "\(baseURL)/caficultores") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(caficultor)
            request.httpBody = encoded
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let newCaficultor = try JSONDecoder().decode(Caficultor.self, from: data)
            
            self.caficultores.append(newCaficultor)
        } catch {
            self.errorMessage = "Error al agregar caficultor: \(error.localizedDescription)"
        }
    }
    
    // PUT (Actualizar un caficultor existente)
    func updateCaficultor(_ caficultor: Caficultor) async {
        guard let url = URL(string: "\(baseURL)/caficultores/\(caficultor.id)") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(caficultor)
            request.httpBody = encoded
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let updated = try JSONDecoder().decode(Caficultor.self, from: data)
            
            if let index = caficultores.firstIndex(where: { $0.id == updated.id }) {
                caficultores[index] = updated
            }
        } catch {
            self.errorMessage = "Error al actualizar caficultor: \(error.localizedDescription)"
        }
    }
    
    // DELETE (Eliminar un caficultor)
    func deleteCaficultor(_ caficultor: Caficultor) async {
        guard let url = URL(string: "\(baseURL)/caficultores/\(caficultor.id)") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) {
                self.caficultores.removeAll { $0.id == caficultor.id }
            } else {
                self.errorMessage = "Error al eliminar caficultor (status: \((response as? HTTPURLResponse)?.statusCode ?? -1))"
                self.hasError = true
            }
        } catch {
            self.errorMessage = "Error al eliminar caficultor: \(error.localizedDescription)"
        }
    }
}
