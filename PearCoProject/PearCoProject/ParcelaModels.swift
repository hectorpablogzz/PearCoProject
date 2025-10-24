//
//  ParcelaModels.swift
//  PearCoProject
//
//  Creado por Alumno el 23/10/25.
//

import Foundation

struct Ubicacion: Codable, Identifiable {
    // idUbicacion cambiado de Int a String para coincidir con UUID
    var idUbicacion: String
    var estado: String
    var municipio: String
    var latitud: Double
    var longitud: Double
    
    var id: String { idUbicacion }

    // Mapea las propiedades de Swift (camelCase) a las columnas de la DB (lowercase)
    enum CodingKeys: String, CodingKey {
        case idUbicacion = "idubicacion" // "idUbicacion" en Swift es "idubicacion" en el JSON
        case estado
        case municipio
        case latitud
        case longitud
    }
}

struct Parcela: Codable, Identifiable {
    // idParcela cambiado de Int a String para coincidir con UUID
    var idParcela: String
    var nombre: String
    var hectareas: Double
    var tipo: String
    var ubicacion: Ubicacion
    
    var id: String { idParcela }

    // Mapea las propiedades de Swift (camelCase) a las columnas de la DB (lowercase)
    enum CodingKeys: String, CodingKey {
        case idParcela = "idparcela" // "idParcela" en Swift es "idparcela" en el JSON
        case nombre
        case hectareas
        case tipo
        case ubicacion
    }
}

// Necesario para decodificar la respuesta {"success": ..., "data": [...]} de tu API
struct ParcelaListResponse: Codable {
    let success: Bool
    let data: [Parcela]
    let error: String?
}

// Necesario para decodificar la respuesta {"success": ..., "data": {...}} de tu API
struct ParcelaResponse: Codable {
    let success: Bool
    let data: Parcela
    let error: String?
}
