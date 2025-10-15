//
//  ModelData.swift
//  PearCoProject
//
//  Created by José Francisco González on 15/10/25.
//

import Foundation
import Observation

@Observable
class DatosEnfermedades {
    @MainActor
    static let shared = DatosEnfermedades()
    
    // Carga inicial de todas las enfermedades desde el JSON
    nonisolated static let enfermedades: [Enfermedad] = cargarEnfermedades(nombreArchivo: "Enfermedades.json")
    
    // Lista de nombres de enfermedades
    nonisolated static var nombresEnfermedades: [String] {
        enfermedades.map(\.nombre)
    }
    
    // Lista de tipos (hongos, insectos, etc.)
    nonisolated static var tipos: [String] {
        Array(Set(enfermedades.map(\.tipo))).sorted()
    }
    
    // Lista de causantes (útil para mostrar fichas informativas)
    nonisolated static var causantes: [String] {
        enfermedades.map(\.causante)
    }
    
    // Diccionario rápido: enfermedad → medidas preventivas
    nonisolated static var medidasPreventivas: [String: [String]] {
        var result: [String: [String]] = [:]
        for enfermedad in enfermedades {
            result[enfermedad.nombre] = enfermedad.control.preventivo
        }
        return result
    }
    
    // Diccionario: enfermedad → medidas químicas
    nonisolated static var medidasQuimicas: [String: [String]] {
        var result: [String: [String]] = [:]
        for enfermedad in enfermedades {
            result[enfermedad.nombre] = enfermedad.control.quimico
        }
        return result
    }
    
    // Diccionario: enfermedad → medidas biológicas (si existen)
    nonisolated static var medidasBiologicas: [String: [String]] {
        var result: [String: [String]] = [:]
        for enfermedad in enfermedades {
            result[enfermedad.nombre] = enfermedad.control.biologico
        }
        return result
    }
    
    // Lista de todas las condiciones favorables únicas
    nonisolated static var condicionesComunes: [String] {
        Array(Set(enfermedades.flatMap(\.condiciones_favorables))).sorted()
    }
    
    // Lista de todos los síntomas únicos
    nonisolated static var sintomasComunes: [String] {
        Array(Set(enfermedades.flatMap(\.sintomas))).sorted()
    }
    
    // Búsqueda por nombre exacto
    nonisolated static func buscarPorNombre(_ nombre: String) -> Enfermedad? {
        enfermedades.first { $0.nombre.lowercased() == nombre.lowercased() }
    }
    
    // Búsqueda por palabra clave (ej. “hojas”, “manchas”, “insecto”)
    nonisolated static func buscarPorPalabraClave(_ palabra: String) -> [Enfermedad] {
        let palabraLower = palabra.lowercased()
        return enfermedades.filter {
            $0.nombre.lowercased().contains(palabraLower) ||
            $0.sintomas.joined(separator: " ").lowercased().contains(palabraLower) ||
            $0.condiciones_favorables.joined(separator: " ").lowercased().contains(palabraLower) ||
            $0.diseminacion.joined(separator: " ").lowercased().contains(palabraLower)
        }
    }
    
    // MARK: - Carga desde archivo JSON
    
    static func cargarEnfermedades(nombreArchivo: String) -> [Enfermedad] {
        guard let archivo = Bundle.main.url(forResource: nombreArchivo, withExtension: nil) else {
            fatalError("No se encontró \(nombreArchivo) en el paquete principal.")
        }

        do {
            let datos = try Data(contentsOf: archivo)
            let decodificador = JSONDecoder()
            
            // Tu JSON tiene un array dentro de un objeto principal { "enfermedades": [...] }
            let contenedor = try decodificador.decode(ContenedorEnfermedades.self, from: datos)
            return contenedor.enfermedades
        } catch {
            fatalError("No se pudo leer \(nombreArchivo):\n\(error)")
        }
    }
}

// MARK: - Modelos de datos

struct ContenedorEnfermedades: Codable {
    let enfermedades: [Enfermedad]
}

struct Enfermedad: Codable, Identifiable {
    let id = UUID()
    let nombre: String
    let causante: String
    let tipo: String
    let sintomas: [String]
    let condiciones_favorables: [String]
    let diseminacion: [String]
    let control: Control
    let impacto: String
}

struct Control: Codable {
    let preventivo: [String]
    let quimico: [String]?
    let biologico: [String]?
    let mecanico: [String]?
    let resistente: [String]?
}
