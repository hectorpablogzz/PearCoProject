//
//  Playground.swift
//  PearCoProject
//
//  Created by Alumno on 14/10/25.
//

import FoundationModels
import Playgrounds

#Playground{
    let session = LanguageModelSession()
    
    let response = try await session.respond(to: "Genera una lista de recomendaciones para curar la broca del café.")
}
