//
//  LoginView.swift
//  PearCoProject
//
//  Created by Alumno on 23/10/25.
//




import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 40) {
                    
                    // Encabezado
                    Text("Bienvenido")
                        .font(.system(size: 55))
                        .greenTitle() // De Styles.swift
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)

                    // Logo o Imagen
                    Image(systemName: "leaf.fill") // Placeholder
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                        .foregroundColor(Color.verdeOscuro) // De Styles.swift

                    // Campos de texto
                    VStack(spacing: 15) {
                        TextField("Correo electrónico", text: $email)
                            .font(.system(size: geo.size.width * 0.045))
                            .padding()
                            .background(Color.grisFondo) // De Styles.swift
                            .cornerRadius(12)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        SecureField("Contraseña", text: $password)
                            .font(.system(size: geo.size.width * 0.045))
                            .padding()
                            .background(Color.grisFondo) // De Styles.swift
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 60)
                    
                    // Mensaje de Error
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: geo.size.width * 0.035))
                            .padding(.horizontal, 60)
                            .multilineTextAlignment(.center)
                    }

                    // Botón de Ingresar
                    Button(action: {
                        authViewModel.login(email: email, password: password)
                    }) {
                        Text("Ingresar")
                            .foregroundColor(.white)
                            .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.verdeBoton) // De Styles.swift
                            .cornerRadius(25)
                            .padding(.horizontal, 130)
                    }
                    
                    Spacer()
                }
                .frame(width: geo.size.width)
                .frame(minHeight: geo.size.height)
            }
            .background(Color.beige)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
