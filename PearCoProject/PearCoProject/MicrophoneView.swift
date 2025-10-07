//
//  MicrophoneView.swift
//  PearCoProject
//
//  Created by marielgonzalezg on 10/09/25.
//


import SwiftUI

struct MicrophoneView: View {
    
    let color: Color
    
    @State private var isOn: Bool = false
    @State private var isThinking: Bool = false
    @State private var initial: Bool = true
    
    @State private var vm: VoiceAssistantVM?
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Latte")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if initial {
                        Text("Ejemplos de lo que puedes preguntar:")
                            .font(.headline)
                        
                        Text("• \"Dime el riesgo de broca en octubre.\"")
                        Text("• \"¿Qué factores impactan en la propagación de roya?\"")
                        Text("• \"Dime maneras de prevenir el ojo de gallo en el café.\"")
                    } else if isThinking {
                        // Mostramos pensando
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: color))
                            Text("Pensando...")
                                .foregroundColor(.gray)
                                .italic()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    } else if let response = vm?.response {
                        // Estilo de la respuesta
                        Text(response)
                            .font(.body)
                            .foregroundColor(.black)
                            .lineSpacing(5)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                    } else if !speechRecognizer.transcript.isEmpty {
                        Text("Escuchando: \(speechRecognizer.transcript)")
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
                        speechRecognizer.startTranscribing()
                    }
                    isOn.toggle()
                }) {
                    Image(systemName: isOn ? "checkmark" : "mic.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 36))
                        .frame(width: 80, height: 80)
                        .background(Circle().fill(color))
                        .shadow(radius: 5)
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

#Preview {
    MicrophoneView(color: Color.green)
}

