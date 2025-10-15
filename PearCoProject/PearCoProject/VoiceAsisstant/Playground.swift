//
//  Playground.swift
//  PearCoProject
//
//  Created by Mariel González on 14/10/25.
//

import FoundationModels
import Playgrounds

#Playground {
    
    let instructions = """
    Eres un asistente de voz especializado en café, diseñado para apoyar y dar recomendaciones a técnicos y caficultores.
    Comunícate de manera clara y sencilla, priorizando la comprensión humana.
    
    Siempre incluye título y descripción.
    """
    
    //start session
    let session = LanguageModelSession(instructions: instructions)
    
    
    // prompt model
    let response = try await session.respond(to: "Genera una lista de recomendaciones para curar la broca del café.")
    
}


#Playground {
    
    let instructions = """
    Eres un asistente de voz especializado en café, diseñado para apoyar y dar recomendaciones a técnicos y caficultores.
    Comunícate de manera clara y sencilla, priorizando la comprensión humana.
    
    Siempre incluye título y descripción.
    """
    
    //start session
    let session = LanguageModelSession(instructions: instructions)
    
    // prompt model
    let response = try await session.respond(to: "Dime cinco recomendaciones para tratar la broca del café.", generating: simpleRecommendations.self)
    
}

@Generable
struct simpleRecommendations{
    @Guide(description: "Título descriptivo para la recomendación.")
    let title: String
    
    @Guide(description: "Una respuesta con recomendaciones descrita de manera clara y humana.")
    let description: String
    
    @Guide(description: "Una lista de dato por dato, como texto simple")
    @Guide(.count(5))
    let datos: [String]
}

#Playground {
    let model = SystemLanguageModel.default

    // The availability property provides detailed information on the model's state.
    switch model.availability {
        case .available:
            print("Foundation Models is available and ready to go!")

        case .unavailable(.deviceNotEligible):
            print("The model is not available on this device.")

        case .unavailable(.appleIntelligenceNotEnabled):
            print("Apple Intelligence is not enabled in Settings.")

        case .unavailable(.modelNotReady):
            print("The model is not ready yet. Please try again later.")

        case .unavailable(let other):
            print("The model is unavailable for an unknown reason.")
    }
}

