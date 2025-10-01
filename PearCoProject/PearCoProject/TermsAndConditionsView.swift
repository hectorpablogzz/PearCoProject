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

    var body: some View {
        ZStack {
            // Fondo oscurecido
            Color.black.opacity(0.45).ignoresSafeArea()
            // Tarjeta centrada
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
                        TermsBodyText()
                    }
                    .padding(16)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                        }
                    )
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
                    .disabled(!(checked))
                }
                .padding(16)
            }
            .frame(maxWidth: 560, maxHeight: 520)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .shadow(radius: 25)
            .padding(.horizontal, 20)
        }
    }
}

private struct TermsBodyText: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TÉRMINOS Y CONDICIONES DE USO").font(.headline)
            Text("Por favor, lea atentamente estos Términos y Condiciones antes de utilizar la aplicación CafeCare. Al acceder o utilizar la aplicación, usted acepta estar sujeto a estos Términos y Condiciones. Si no está de acuerdo con alguno de estos términos, le recomendamos no utilizar la aplicación.")

            Text("1. OBJETO DE LA APLICACIÓN").font(.headline)
            Text("La aplicación proporciona información sobre parcelas agrícolas, datos climáticos, condiciones del terreno y una estimación de la probabilidad de aparición de ciertas enfermedades en cultivos, basada en modelos estadísticos y fuentes de datos disponibles. IMPORTANTE: La información provista es únicamente referencial e informativa. No constituye una confirmación ni diagnóstico definitivo sobre la presencia de enfermedades agrícolas. El usuario debe consultar con expertos o autoridades competentes antes de tomar decisiones agrícolas o sanitarias basadas en la información de la aplicación.")

            Text("2. REGISTRO Y USO DE DATOS PERSONALES").font(.headline)
            Text("Para utilizar la Aplicación, es posible que se le solicite proporcionar cierta información personal, incluyendo:") +
            Text("Correo electrónico") +
            Text("Contraseña") +
            Text("Datos sobre sus parcelas (ubicación, tipo de cultivo, historial, etc.)") +
            Text("Al registrarse, usted declara que la información proporcionada es veraz, completa y actualizada. También acepta que nosotros almacenemos y procesemos estos datos conforme a nuestra [Política de Privacidad].") +
            Text("2.1 Uso de Datos") +
            Text("Los datos recopilados se utilizarán para:") +
            Text("Brindar las funcionalidades principales de la Aplicación") +
            Text("Mejorar la calidad del servicio y personalizar la experiencia del usuario") +
            Text("Desarrollar modelos predictivos y analíticos (de forma agregada y anonimizada)") +
            Text("Contactarle con información relevante sobre el servicio") +
            Text("No compartimos datos personales identificables con terceros sin su consentimiento, salvo en los casos exigidos por ley.")

            Text("3. LIMITACIÓN DE RESPONSABILIDAD").font(.headline)
            Text("Usted comprende y acepta que:") +
            Text("La información proporcionada por la Aplicación es una estimación basada en datos y modelos probabilísticos, y puede contener errores, omisiones o inexactitudes.") +
            Text("No garantizamos ni afirmamos la presencia o ausencia de enfermedades en cultivos.") +
            Text("El uso de esta información es bajo su propia responsabilidad. No nos hacemos responsables de decisiones agrícolas, económicas o sanitarias tomadas en base a la Aplicación.") +
            Text("La Aplicación puede verse interrumpida por mantenimiento, actualizaciones o fallos técnicos.")

            Text("4. PROPIEDAD INTELECTUAL").font(.headline)
            Text("Todos los contenidos de la Aplicación, incluyendo textos, imágenes, modelos de predicción, bases de datos, interfaces, y código fuente, son propiedad exclusiva de [Nombre del desarrollador o empresa], o se utilizan bajo licencia, y están protegidos por las leyes de propiedad intelectual.") +
            Text("Queda prohibido:") +
            Text("Copiar, reproducir, distribuir o modificar cualquier parte de la Aplicación sin autorización previa por escrito.") +
            Text("Utilizar ingeniería inversa sobre el software o sus componentes.")
            
            Text("5. CONDUCTA DEL USUARIO").font(.headline)
            Text("Usted se compromete a:") +
            Text("No utilizar la Aplicación con fines ilegales, fraudulentos o no autorizados.") +
            Text("No intentar acceder a datos de otros usuarios o comprometer la seguridad del sistema.") +
            Text("Mantener la confidencialidad de su contraseña y cuenta de usuario.")
            
            Text("6. MODIFICACIONES").font(.headline)
            Text("Nos reservamos el derecho a modificar estos Términos y Condiciones en cualquier momento. Le notificaremos los cambios relevantes a través de la Aplicación o al correo electrónico proporcionado. El uso continuado después de dichos cambios implica su aceptación.")
            
            Text("7. CANCELACIÓN DE CUENTA").font(.headline)
            Text("Usted puede cancelar su cuenta en cualquier momento desde la Aplicación o solicitándolo a nuestro equipo de soporte. Nos reservamos el derecho de suspender o eliminar cuentas que incumplan estos Términos.")
            
            Text("8. LEGISLACIÓN APLICABLE").font(.headline)
            Text("Estos Términos se regirán e interpretarán conforme a las leyes de [país o jurisdicción aplicable]. Cualquier disputa será resuelta ante los tribunales competentes de dicha jurisdicción.")
            
            Text("9. CONTACTO").font(.headline)
            Text("Si tiene preguntas sobre estos Términos o sobre el uso de sus datos, puede contactarnos en:") +
            Text("📧 Correo electrónico: [correo@ejemplo.com]") +
            Text("📍 Dirección: [Dirección de la empresa o responsable]")
        }
    }
}
