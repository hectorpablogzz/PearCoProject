//
//  VoiceAssistantVM.swift
//  PearCoProject
//
//  Created by marielgonzalezg on 07/10/25.
//

import Foundation
import FoundationModels
import Observation
import Speech

@MainActor
final class VoiceAssistantVM: ObservableObject {
    @Published private(set) var response: String?
    @Published var error: Error?
    
    let prompt: String
    private var session: Any?
    
    init(prompt: String) {
        self.prompt = prompt
        
        let instructions = """
        Eres un asistente de voz especializado en café, diseñado para apoyar a técnicos y caficultores.
        Comunícate con diálogo amigable con lenguaje natural.
        
        Los síntomas principales de la broca del café son la aparición de un pequeño orificio (1 mm) en el fruto (baya), a menudo con un depósito marrón, gris o verde alrededor. Otros signos incluyen la caída prematura de los frutos, lesiones negras o marrones y, al abrir los frutos, daños internos en el grano que pueden llevar a su pudrición. 
        
        La broca del café se hace más propensa por las condiciones ambientales, como la alta humedad (50% a 90%) y temperaturas cálidas (18°C a 25°C).
        """
        
        self.session = LanguageModelSession(instructions: instructions)
    }
    
    func generateResponse() async {
        guard #available(iOS 26.0, *),
              let session = session as? LanguageModelSession else { return }
        do {
            let result = try await session.respond(to: prompt)
            await MainActor.run { self.response = result.content }
        } catch {
            await MainActor.run { self.error = error }
            print("⚠️ Error generando respuesta: \(error.localizedDescription)")
        }
    }
}
