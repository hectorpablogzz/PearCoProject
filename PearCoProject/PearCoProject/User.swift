//
//  User.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//

import Foundation
import SwiftUI

struct User: Codable, Identifiable {
    // --- CORRECCIÓN AQUÍ ---
    // El 'id' (y 'idusuario') debe ser String para coincidir con el UUID de la DB
    var id: String { idusuario }
    let idusuario: String
    let nombre: String
    let apellido: String
    let correo: String
    
    // --- CORRECCIÓN AQUÍ ---
    // 'idparcela' también es un UUID, por lo tanto, String
    let idparcela: String
    
    // 'idtipousuario' es Int, lo cual es correcto
    let idtipousuario: Int

    // --- ¡CORRECCIÓN AQUÍ! ---
    // Mapea las propiedades de Swift (camelCase) a las columnas de la DB (lowercase)
    enum CodingKeys: String, CodingKey {
        case idusuario
        case nombre
        case apellido
        case correo
        case idparcela
        case idtipousuario
    }
}

struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let data: User?
}
