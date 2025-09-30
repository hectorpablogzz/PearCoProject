//
//  TermsAndConditionsView.swift
//  PearCoProject
//
//  Created by Alumno on 30/09/25.
//

import SwiftUI

struct TermsAndConditionsView: View {
    var title: String = "Términos y Condiciones"
    var accent: Color = .accentColor
    var onAccept: () -> Void

    @State private var checked = false
    @State private var atBottom = false

    var body: some View {
        ZStack {
            // Fondo oscurecido
            Color.black.opacity(0.45).ignoresSafeArea()

            // Tarjeta centrada (más pequeña para que se vea Home atrás)
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(title).font(.title3).bold()
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)

                Divider()

                // Contenido con detección de "llegué al final"
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        TermsBodyText() // <-- pon aquí tu texto real
                        // (no hace falta id de ancla con este detector)
                    }
                    .padding(16)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: _ContentSizeKey.self, value: geo.size.height)
                        }
                    )
                }
                .modifier(_BottomReachedSimple(atBottom: $atBottom))
                .overlay(alignment: .bottomTrailing) {
                    Text(atBottom ? "Listo ✅" : "Desliza hasta el final ⬇️")
                        .font(.caption2).foregroundStyle(.secondary)
                        .padding(.trailing, 10)
                        .padding(.bottom, 8)
                }

                Divider()

                // Controles
                VStack(alignment: .leading, spacing: 12) {
                    Toggle(isOn: $checked) {
                        Text("He leído y acepto los términos y el aviso de privacidad.")
                    }
                    .tint(accent)

                    Button {
                        onAccept()
                    } label: {
                        Text("Aceptar")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(accent)
                    .disabled(!(checked && atBottom))
                }
                .padding(16)
            }
            .frame(maxWidth: 560, maxHeight: 520)
            .background(
                // OJO: Material directo (no uses Color.ultraThinMaterial)
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .shadow(radius: 25)
            .padding(.horizontal, 20)
        }
    }
}

// Texto demo para forzar scroll (reemplaza por tus T&C)
private struct TermsBodyText: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("1) Aceptación").font(.headline)
            Text("Al usar la app aceptas estos términos...")

            Text("2) Uso permitido").font(.headline)
            Text("Esta app apoya decisiones agronómicas; úsala de forma responsable...")

            Text("3) Datos y privacidad").font(.headline)
            Text("Procesamos datos de clima y cultivo para estimar riesgos...")

            Text("4) Limitación de responsabilidad").font(.headline)
            Text("Las estimaciones no garantizan resultados; verifica en campo...")

            Text("5) Actualizaciones").font(.headline)
            Text("Podemos actualizar los términos cuando sea necesario...")

            // Relleno para que haya scroll
            ForEach(0..<8) { _ in
                Text("Aviso: las métricas de riesgo (roya, broca, ojo de gallo, antracnosis) se basan en modelos y pueden variar por condiciones locales.")
            }
        }
    }
}

// === utilería mínima para detectar “llegué al fondo” ===

private struct _ContentSizeKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

/// Considera que llegó al fondo si desplazamiento + alto visible >= alto del contenido - tolerancia
private struct _BottomReachedSimple: ViewModifier {
    @Binding var atBottom: Bool
    var tolerance: CGFloat = 24

    @State private var contentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { outer in
            content
                .onPreferenceChange(_ContentSizeKey.self) { contentHeight = $0 }
                .background(
                    _ScrollOffsetReader { y, visibleH in
                        let reached = (-y + visibleH) >= (contentHeight - tolerance)
                        if reached != atBottom { atBottom = reached }
                    }
                )
        }
    }
}

private struct _ScrollOffsetReader: UIViewRepresentable {
    let onChange: (_ offsetY: CGFloat, _ visibleHeight: CGFloat) -> Void

    func makeUIView(context: Context) -> UIScrollView {
        let sv = UIScrollView()
        sv.delegate = context.coordinator
        return sv
    }
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(onChange) }

    final class Coordinator: NSObject, UIScrollViewDelegate {
        let onChange: (_ y: CGFloat, _ h: CGFloat) -> Void
        init(_ onChange: @escaping (_ y: CGFloat, _ h: CGFloat) -> Void) { self.onChange = onChange }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            onChange(scrollView.contentOffset.y, scrollView.bounds.height)
        }
        func scrollViewDidLayoutSubviews(_ scrollView: UIScrollView) {
            onChange(scrollView.contentOffset.y, scrollView.bounds.height)
        }
    }
}
