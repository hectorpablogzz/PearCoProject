//
//  Ubicacion.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//



import Foundation

struct Ubicacion: Codable, Identifiable {
    var idUbicacion: Int
    var estado: String
    var municipio: String
    var latitud: Double
    var longitud: Double
    
    var id: Int { idUbicacion }
}

struct Parcela: Codable, Identifiable {
    var idParcela: Int
    var nombre: String
    var hectareas: Double
    var tipo: String
    var ubicacion: Ubicacion
    
    var id: Int { idParcela }
}
