//
//  LoginView .swift
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
        NavigationStack {
            if authViewModel.isAuthenticated {
                AlertView()
                    .environmentObject(authViewModel)
            } else {
                VStack(spacing: 30) {
                    Text("Bienvenido")
                        .font(.largeTitle)
                        .padding(.top, 50)
                
                    Image("LogoCafeCare")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)

                    TextField("Correo electrónico", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    
                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Ingresar") {
                        authViewModel.login(email: email, password: password)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                }
                .padding(.horizontal, 50)

            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
