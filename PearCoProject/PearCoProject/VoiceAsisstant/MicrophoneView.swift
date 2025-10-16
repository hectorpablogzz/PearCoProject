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
    //@State private var RecommendationsGenerator: RecommendationsGenerator?
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("¡Pregúntale a Latte!")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    if initial {
                        Text("Ejemplos de lo que puedes preguntar:")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("• \"Dime el riesgo de broca en octubre.\"")
                            Text("• \"¿Qué factores impactan en la roya del café?\"")
                            Text("• \"Cómo prevenir el ojo de gallo en el café.\"")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                    } else if isThinking {
                        HStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: color))
                            Text("Pensando...")
                                .foregroundColor(.gray)
                                .italic()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        
                    } else if let response = vm?.response {
                        LatteCleanMarkdownText(text: response)
                        
                    } else if !speechRecognizer.transcript.isEmpty {
                        Text("Escuchando: \(speechRecognizer.transcript)")
                            .italic()
                            .foregroundColor(.gray)
                        
                    } else {
                        Text("Di algo…")
                            .italic()
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            
            Spacer()
        }
        .padding(.bottom, 10)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                
                Button(action: {
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
                    
                    isOn.toggle()
                }) {
                    Image(systemName: isOn ? "checkmark" : "mic.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 36, weight: .bold))
                        .frame(width: 80, height: 80)
                        .background(Circle().fill(color))
                        .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                        .scaleEffect(isOn ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isOn)
                }
                .disabled(isThinking)
                .opacity(isThinking ? 0.3 : 1.0)
                
                Spacer()
            }
            .padding(.vertical, 15)
            .background(Color.white.opacity(0.95))
        }
    }
}

struct LatteCleanMarkdownText: View {
    let text: String
    
    var body: some View {
        ScrollView {
            Text(processedText(text))
                .font(.system(size: 18))
                .foregroundColor(.primary)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.systemGray6))
                        .shadow(color: .gray.opacity(0.15), radius: 3, x: 0, y: 2)
                )
                .padding(.top, 8)
        }
    }
    
    func processedText(_ raw: String) -> String {
        var clean = raw
        
        // Mantener saltos de línea existentes
        clean = clean.replacingOccurrences(of: "\r", with: "")
        
        // Encabezados (#) → línea separada
        clean = clean.replacingOccurrences(of: "#", with: "\n\n")
        
        // Listas con guión → bullet points
        clean = clean.replacingOccurrences(of: "- ", with: "• ")
        
        // Listas numeradas ya tienen "1.", "2.", etc., dejar como están
        
        // Quitar caracteres Markdown innecesarios
        clean = clean.replacingOccurrences(of: "*", with: "")
        clean = clean.replacingOccurrences(of: "**", with: "")
        
        // Evitar múltiples saltos de línea consecutivos
        while clean.contains("\n\n\n") {
            clean = clean.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }
        
        // Trim final
        return clean.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    MicrophoneView(color: .green)
}
