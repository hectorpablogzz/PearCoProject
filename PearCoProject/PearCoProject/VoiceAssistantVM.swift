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
    private var session: LanguageModelSession?
    private let model = SystemLanguageModel.default
    
    init(prompt: String) {
        self.prompt = prompt
        
        // Check model availability
        switch model.availability {
        case .available:
            let instructions = """
            Eres un asistente de voz especializado en café, diseñado para apoyar a técnicos y caficultores.
            Comunícate de manera clara y sencilla, priorizando la comprensión humana.
            
            Siempre incluye título y descripción.
            """
            self.session = LanguageModelSession(instructions: instructions)
        
        case .unavailable(.appleIntelligenceNotEnabled):
            self.error = NSError(
                domain: "VoiceAssistant",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence no está activado."]
            )
            
        case .unavailable(let reason):
            self.error = NSError(
                domain: "VoiceAssistant",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "El modelo no está disponible: \(reason)"]
            )
        }
    }
    
    func generateResponse() async {
        guard let session else {
            print("⚠️ No hay sesión activa. Verifica disponibilidad.")
            return
        }
        
        do {
            let result = try await session.respond(to: prompt)
            await MainActor.run {
                self.response = result.content
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
            print("⚠️ Error generando respuesta: \(error.localizedDescription)")
        }
    }
}
