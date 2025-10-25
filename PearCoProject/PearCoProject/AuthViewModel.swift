//
//  AuthViewModel.swift
//  PearCoProject
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {

    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var currentUser: User? // Uses User struct from User.swift
    @Published var idUser: String? = nil

    // --- USANDO URL DE RENDER ---
    private let apiURL = "https://pearcoflaskapi.onrender.com/login"

    func login(email: String, password: String) {
        self.errorMessage = nil
        print("🚀 Iniciando login con email: \(email)...")

        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Por favor, ingrese correo y contraseña."; return
        }
        guard let url = URL(string: apiURL) else {
            self.errorMessage = "URL API inválida: \(apiURL)"; print("🚨 Bad URL"); return
        }

        let loginData = ["email": email.lowercased(), "password": password]

        Task {
            do {
                var request = URLRequest(url: url); request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(loginData)

                print("📡 POST \(apiURL)...")
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Respuesta inválida (no HTTP)."; print("🚨 No HTTP"); return
                }
                print("📬 Response Code: \(httpResponse.statusCode)")
                guard !data.isEmpty else {
                    self.errorMessage = "Respuesta vacía (\(httpResponse.statusCode))."; print("🚨 Empty Data"); return
                }
                if let responseString = String(data: data, encoding: .utf8) { print("📄 Raw Response: \(responseString)") }

                // Decode always to get potential error message
                let apiResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                print("✅ Decoded Response: \(apiResponse)")

                if httpResponse.statusCode == 200 && apiResponse.success, let user = apiResponse.data {
                    print("🎉 Login Success! User: \(user.nombre), ID: \(user.idusuario)")
                    self.currentUser = user
                    self.isAuthenticated = true // <<< STATE CHANGE
                    print("✅ isAuthenticated set to: \(self.isAuthenticated)") // Debug print
                    self.idUser = user.idusuario
                } else {
                    let message = apiResponse.message.isEmpty ? "Error (\(httpResponse.statusCode))" : apiResponse.message
                    print("❌ Login Failed: \(message)")
                    self.errorMessage = message
                }

            } catch let error as DecodingError {
                print("🚨 DECODING ERROR: \(error)")
                self.errorMessage = "Error procesando respuesta: \(error.localizedDescription)"
                // Log details
                switch error {
                    case .keyNotFound(let key, let context): print("   - Key '\(key.stringValue)' missing. Path: \(context.codingPath)")
                    case .typeMismatch(let type, let context): print("   - Type mismatch for '\(context.codingPath.last?.stringValue ?? "?")'. Expected \(type). Path: \(context.codingPath)")
                    case .valueNotFound(let type, let context): print("   - Value missing/null for '\(context.codingPath.last?.stringValue ?? "?")'. Expected \(type). Path: \(context.codingPath)")
                    case .dataCorrupted(let context): print("   - Corrupt data. Path: \(context.codingPath)")
                    @unknown default: print("   - Unknown decoding error.")
                }
            } catch {
                print("🚨 NETWORK/CONNECTION ERROR: \(error)")
                self.errorMessage = "Error de conexión: \(error.localizedDescription)."
            }
        }
    }

    func logout() {
        print("🚪 Logging out...")
        self.isAuthenticated = false
        self.currentUser = nil
        self.errorMessage = nil
        self.idUser = nil
    }
}
