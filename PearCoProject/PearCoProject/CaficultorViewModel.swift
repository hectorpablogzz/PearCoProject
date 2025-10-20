//
//  CaficultorVM.swift
//  DataPersistenceDB
//
//  Created by Héctor Pablo González on 19/10/25.
//

import Foundation
internal import Combine

@MainActor
class CaficultorVM: ObservableObject {
    
    @Published var isConnected: Bool = true
    private var cancellables = Set<AnyCancellable>()

    init(monitor: NetworkMonitor = .shared) {
        monitor.$isConnected
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)   // shortest Combine wiring
    }
    
    func addCaficultor(_ caficultor: Caficultor) async {
        print(caficultor.name)
        guard let url = URL(string: "https://pearcoflaskapi.onrender.com/caficultores") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(caficultor)
            request.httpBody = encoded
            
            let (data, _) = try await URLSession.shared.data(for: request)

        } catch {
            print("Error al agregar caficultor: \(error.localizedDescription)")
        }
    }
    
    // PUT (Actualizar un caficultor existente)
    func updateCaficultor(_ caficultor: Caficultor) async {
        guard let url = URL(string: "https://pearcoflaskapi.onrender.com/caficultores/\(caficultor.id)") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(caficultor)
            request.httpBody = encoded
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
        } catch {
            print("Error al actualizar caficultor: \(error.localizedDescription)")
        }
    }
    
    // DELETE (Eliminar caficultor)
    func deleteCaficultor(_ id: UUID) async {
        guard let url = URL(string: "https://pearcoflaskapi.onrender.com/caficultores/\(id)") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            print("Error al eliminar caficultor: \(error.localizedDescription)")
        }
    }
}
