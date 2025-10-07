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
        Eres un asistente de voz especializado en café, diseñado para apoyar a caficultores.
        Comunícate de manera clara y sencilla, priorizando comprensión auditiva.
        """
        
        if #available(iOS 26.0, *) {
            self.session = LanguageModelSession(instructions: instructions)
        } else { self.session = nil }
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
