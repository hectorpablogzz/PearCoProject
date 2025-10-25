//
//  Ubicacion.swift
//  PearCoProject
//
//  Created by Alumno on 25/10/25.
//


//
//  ParcelaModels.swift
//  PearCoProject
//

import Foundation

struct Ubicacion: Codable, Identifiable {
    var idUbicacion: String
    var estado: String
    var municipio: String
    var latitud: Double
    var longitud: Double

    var id: String { idUbicacion }

    // Mapea JSON (lowercase) a Swift (camelCase)
    enum CodingKeys: String, CodingKey {
        case idUbicacion = "idubicacion"
        case estado
        case municipio
        case latitud
        case longitud
    }
}

struct Parcela: Codable, Identifiable {
    var idParcela: String
    var nombre: String
    var hectareas: Double
    var tipo: String
    var ubicacion: Ubicacion // Objeto anidado

    var id: String { idParcela }

    // Mapea JSON (lowercase) a Swift (camelCase)
    enum CodingKeys: String, CodingKey {
        case idParcela = "idparcela"
        case nombre
        case hectareas
        case tipo
        case ubicacion // Swift decodificará el objeto anidado automáticamente
    }
}

// Para GET /parcelas (lista) - Respuesta de la API envuelta
struct ParcelaListResponse: Codable {
    let success: Bool
    let data: [Parcela] // La lista está dentro de 'data'
    let error: String?
}

// Para GET /parcelas/{id}, POST, PUT (objeto único) - Respuesta envuelta
struct ParcelaResponse: Codable {
    let success: Bool
    let data: Parcela // El objeto está dentro de 'data'
    let error: String?
}

// Para DELETE /parcelas/{id} (respuesta simple)
struct DeleteResponse: Codable {
    let success: Bool
    let data: String? // El mensaje de éxito está en 'data' según tu API
    let error: String?
}