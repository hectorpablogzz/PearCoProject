//
//  RecommendationsGenerator.swift
//  PearCoProject
//
//  Created by José Francisco González on 15/10/25.
//

import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class RecommendationsGenerator {
    var error: Error?
    
    private var session: LanguageModelSession
    
    
    private(set) var Recommendations: String?
    
    init(error: Error? = nil, session: LanguageModelSession, Recommendations: String? = nil) {
        self.error = error
        self.session = session
        self.Recommendations = Recommendations
        
        let instructions = """
        Eres un asistente de voz especializado en café, diseñado para apoyar y dar recomendaciones a técnicos y caficultores.
        Comunícate de manera clara y sencilla, priorizando la comprensión humana.
        
        Siempre incluye título y descripción.
        """
        
        self.session = LanguageModelSession(instructions:instructions)
    }
    
    func generateRecommendations() async{
        do{
            let prompt = "Genera recomendaciones para curar la enfermedad dicha por el usuario."
            let response = try await session.respond(to: prompt)
            self.Recommendations = response.content
        }catch{
            self.error = error
        }
    }
}
