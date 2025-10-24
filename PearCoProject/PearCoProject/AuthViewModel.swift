//
//  AuthViewModel.swift
//  PearCoProject
//
//  Creado a partir de la versión del 23/10/25.
//

import Foundation
import SwiftUI

struct User: Codable, Identifiable {
    var id: String { idusuario }
    let idusuario: String
    let nombre: String
    let apellido: String
    let correo: String
    let idparcela: String
}

struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let data: User?
}

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    @Published var idUser: String? = nil

    private let apiURL = "http://127.0.0.1:5050/login"

    func login(email: String, password: String) {
        self.errorMessage = nil
        
        guard let url = URL(string: apiURL) else {
            self.errorMessage = "La URL del API no es válida."
            return
        }
        
        let loginData = ["email": email.lowercased(), "password": password]
        
        Task {
            do {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(loginData)
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                guard !data.isEmpty else {
                    self.errorMessage = "El servidor no devolvió datos."
                    return
                }
                
                let apiResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                if apiResponse.success, let user = apiResponse.data {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.idUser = user.idusuario
                } else {
                    self.errorMessage = apiResponse.message
                }
                
            } catch {
                self.errorMessage = "Error de conexión o decodificación: \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
        self.isAuthenticated = false
        self.currentUser = nil
        self.errorMessage = nil
        self.idUser = nil
    }
}
