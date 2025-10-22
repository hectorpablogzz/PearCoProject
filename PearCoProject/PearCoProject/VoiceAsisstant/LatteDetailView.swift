//
//  LatteDetailView.swift
//  PearCoProject
//
//  Created by José Francisco González on 15/10/25.
//

import FoundationModels
import SwiftUI

struct LatteDetailView: View {
    let color: Color
    
    private let model = SystemLanguageModel.default
    

    var body: some View {
        switch model.availability {
        case .available:
            MicrophoneView(color: .verdeOscuro)
            
        case .unavailable(.appleIntelligenceNotEnabled):
            MessageView(
                message: """
                         Latte no está disponible porque \
                         Apple Intelligence no está prendido.
                         """
            )
        case .unavailable(.deviceNotEligible):
            MessageView(
                message: """
                Latte no está disponible porque \
                el dispositivo no es elegible.
                """
                )
        case .unavailable(.modelNotReady):
            MessageView(
                message: """
                Latte no está disponible porque \
                el dispositivo no es elegible.
                """
                )
        case.unavailable(_):
            MessageView(
                message: """
                Latte no está disponible por razón desconocida.
                """
                )
            
        @unknown default:
            MessageView(
                message: """
                         Latte no está disponible. Intenta de nuevo después.
                         """
            )
        }
    }
}
