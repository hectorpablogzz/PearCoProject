//
//  VoiceATesting.swift
//  VoiceATesting
//
//  Created by marielgonzalezg on 23/10/25.
//

import Testing
@testable import PearCoProject
import FoundationModels


struct VoiceATesting {
    
    @Test("Response must not be empty or whitespace")
    func testHasValidResponse() async throws {
        // Crear instancia en MainActor
        let vm = await MainActor.run { VoiceAssistantVM(prompt: "Describe la broca del café") }
        
        // Asignar response usando el helper de testing
        await MainActor.run {
            vm._setResponseForTesting("La broca del café es un insecto que daña los granos.")
            #expect(vm.hasValidResponse()) // ✅ válida
            
            vm._setResponseForTesting(" ")
            #expect(!vm.hasValidResponse()) // ❌ solo espacios
            
            vm._setResponseForTesting(nil)
            #expect(!vm.hasValidResponse()) // ❌ nil
        }
        
    }
    
    
    @Test("Device must have Apple Intelligence enabled")
    func testIsAppleIntelligenceEnabled() async throws {
        await MainActor.run {
            let availability = SystemLanguageModel.default.availability
            
            switch availability {
            case .available:
                #expect(true) // ✅ Apple Intelligence disponible
            case .unavailable(let reason):
                #expect(false, "Apple Intelligence no está habilitado: \(reason)") // ❌
            @unknown default:
                #expect(false, "Estado desconocido de Apple Intelligence") // ❌
            }
            
        }
    }
}
