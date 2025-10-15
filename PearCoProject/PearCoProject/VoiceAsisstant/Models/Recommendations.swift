//
//  RecommendationsGenerator.swift
//  PearCoProject
//
//  Created by José Francisco González on 15/10/25.
//


import Foundation
import FoundationModels
import Observation

@Generable
struct RecomendacionesEnfermedad: Equatable {
    @Guide(.anyOf(DatosEnfermedades.nombresEnfermedades))
    let enfermedad: String

    @Guide(description: "Título descriptivo para la recomendación.")
    let title: String

    @Guide(description: "Una respuesta con recomendaciones descrita de manera clara y humana.")
    let description: String

    @Guide(description: "Una lista de consejos o datos puntuales con texto claro y simple.")
    @Guide(.count(5))
    let datos: [String]

}
