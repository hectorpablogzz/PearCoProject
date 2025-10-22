//
//  MicrophoneView.swift
//  PearCoProject
//
//  Created by marielgonzalezg on 10/09/25.
//

import SwiftUI
import FoundationModels

struct MicrophoneView: View {
    
    let color: Color
    
    @State private var isOn: Bool = false
    @State private var isThinking: Bool = false
    @State private var initial: Bool = true
    
    @State private var vm: VoiceAssistantVM?
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.15))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "cup.and.heat.waves.fill")
                            .font(.system(size: 36, weight: .medium))
                            .foregroundColor(color)
                    }
                    .padding(.top, 20)
                    
                    Text("¡Pregúntale a Latte!")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Tu asistente de voz especializado en café")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 24)
                
                // Contenido
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        
                        if initial {
                            initialStateView
                        } else if isThinking {
                            thinkingStateView
                        } else if let response = vm?.response {
                            responseView(response)
                        } else if !speechRecognizer.transcript.isEmpty {
                            listeningView
                        } else {
                            emptyStateView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            microphoneButton
        }
    }
    
    // MARK: - Subvistas
    
    private var initialStateView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(color)
                Text("Sugerencias")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
            
            VStack(spacing: 10) {
                exampleCard("¿Cuándo es más propensa a aparecer la broca del café?", icon: "calendar")
                exampleCard("¿Cuáles son los síntomas de la broca del café?", icon: "cross.case.fill")
                exampleCard("¿Cómo controlo el ojo de gallo en el café?", icon: "leaf.fill")
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
    
    private func exampleCard(_ text: String, icon: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(color)
                .frame(width: 32, height: 32)
            
            Text(text)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private var thinkingStateView: some View {
        VStack(spacing: 24) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: color))
                .scaleEffect(1.5)
            
            VStack(spacing: 6) {
                Text("Pensando")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Analizando tu pregunta...")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
    
    private func responseView(_ response: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack(spacing: 10) {

                
                
                Spacer()
            }
            .padding(.horizontal, 4)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(.init(processedText(response)))
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .lineSpacing(8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            HStack(spacing: 12) {
                Button(action: {
                    UIPasteboard.general.string = response
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 14, weight: .medium))
                        Text("Copiar")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                
                Button(action: {
                    // Nueva pregunta
                    initial = false
                    vm = nil
                    speechRecognizer.transcript = ""
                    speechRecognizer.startTranscribing()
                    isOn = true
                    
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .medium))
                        Text("Nueva pregunta")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                
                Spacer()
            }
            .padding(.horizontal, 4)
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
    
    private var listeningView: some View {
        VStack(spacing: 20) {
            HStack(spacing: 6) {
                ForEach(0..<4) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: 3, height: isOn ? CGFloat.random(in: 15...40) : 15)
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.1),
                            value: isOn
                        )
                }
            }
            .padding(.top, 20)
            
            VStack(spacing: 8) {
                Text("Escuchando...")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(speechRecognizer.transcript)
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "waveform")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(color.opacity(0.6))
            
            Text("Comienza a hablar...")
                .font(.system(size: 17))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private var microphoneButton: some View {
        HStack {
            Spacer()
            
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                initial = false
                
                if isOn {
                    speechRecognizer.stopTranscribing()
                    
                    if !speechRecognizer.transcript.isEmpty {
                        vm = VoiceAssistantVM(prompt: speechRecognizer.transcript)
                        Task {
                            isThinking = true
                            await vm?.generateResponse()
                            isThinking = false
                        }
                    }
                } else {
                    vm = nil
                    speechRecognizer.transcript = ""
                    speechRecognizer.startTranscribing()
                }
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isOn.toggle()
                }
            }) {
                ZStack {
                    
                    if isOn {
                        Circle()
                            .stroke(color.opacity(0.2), lineWidth: 2)
                            .frame(width: 96, height: 96)
                            .scaleEffect(isOn ? 1 : 0.8)
                            .opacity(isOn ? 1 : 0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isOn)
                    }
                    
                    // Botón principal
                    ZStack {
                        Circle()
                            .fill(color)
                            .frame(width: 72, height: 72)
                        
                        Image(systemName: isOn ? "checkmark" : "mic.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .shadow(color: color.opacity(0.3), radius: 12, x: 0, y: 6)
                    .scaleEffect(isOn ? 1.05 : 1.0)
                }
            }
            .disabled(isThinking)
            .opacity(isThinking ? 0.5 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isOn)
            
            Spacer()
        }
        .frame(height: 100)
        .background(.ultraThinMaterial)
    }
    
    func processedText(_ raw: String) -> String {
        var clean = raw
        
        clean = clean.replacingOccurrences(of: "**", with: "")
        clean = clean.replacingOccurrences(of: "*", with: "")
        clean = clean.replacingOccurrences(of: "##", with: "")
        clean = clean.replacingOccurrences(of: "#", with: "")
        clean = clean.replacingOccurrences(of: "- ", with: "• ")
        clean = clean.replacingOccurrences(of: "\n\n", with: "\n \n")
        
        return clean.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    MicrophoneView(color: .green)
}
