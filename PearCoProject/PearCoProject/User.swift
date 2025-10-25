//
//  User.swift
//  PearCoProject
//

import Foundation

// MARK: - User Model (SIN idtipousuario)
struct User: Codable, Identifiable {
    var id: String { idusuario }
    let idusuario: String
    let nombre: String
    let apellido: String
    let correo: String
    let idparcela: String       // UUID -> String
    // let idtipousuario: Int   // <-- REMOVED

    // CodingKeys (SIN idtipousuario)
    enum CodingKeys: String, CodingKey {
        case idusuario
        case nombre
        case apellido
        case correo
        case idparcela
        // case idtipousuario // <-- REMOVED
    }
}

// MARK: - API Response Model (No changes needed here)
struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let data: User? // This still uses the updated User struct
}
