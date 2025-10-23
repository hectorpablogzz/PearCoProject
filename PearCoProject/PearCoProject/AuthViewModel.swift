//
//  User.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//



import Foundation

// Define la estructura del usuario (debe coincidir con tu tabla 'usuarios')
struct User: Codable, Identifiable {
    var id: Int { idusuario }
    let idusuario: Int
    let nombre: String
    let apellido: String
    let correo: String
    // La contraseña ya NO se recibe del servidor
    let idparcela: Int
    let idtipousuario: Int
}

// Estructura para decodificar la respuesta del servidor
struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let data: User? // 'data' contiene al usuario si el login es exitoso
}

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    // --- ¡IMPORTANTE! ---
    // Reemplaza esto con la URL real de tu API de Python
    // Si pruebas en el simulador y tu PC, usa la IP de tu PC:
    // private let apiURL = "http://192.168.1.100:5050/login"
    private let apiURL = "http://TU_IP_O_DOMINIO:5050/login"

    func login(email: String, password: String) {
        
        self.errorMessage = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Por favor, ingrese correo y contraseña."
            return
        }
        
        guard let url = URL(string: apiURL) else {
            self.errorMessage = "La URL del API no es válida."
            return
        }

        // 1. Preparar los datos para enviar (JSON)
        let loginData = ["email": email.lowercased(), "password": password]
        
        Task {
            do {
                // 2. Configurar la petición como POST
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(loginData)
                
                // 3. Enviar la petición
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard (response as? HTTPURLResponse) != nil else {
                    self.errorMessage = "Respuesta inválida del servidor."
                    return
                }
                
                // 4. Decodificar la respuesta del servidor (LoginResponse)
                let apiResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                if apiResponse.success, let user = apiResponse.data {
                    // ¡Éxito!
                    self.currentUser = user
                    self.isAuthenticated = true
                } else {
                    // Fracaso (usamos el mensaje de error del servidor)
                    self.errorMessage = apiResponse.message
                }
                
            } catch {
                // Error de red, decodificación, etc.
                self.errorMessage = "Error de conexión. Revisa la URL y que el servidor esté corriendo. \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
        self.isAuthenticated = false
        self.currentUser = nil
        self.errorMessage = nil
    }
}
