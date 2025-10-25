//
//  LoginView.swift
//  PearCoProject
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var didAttemptLogin = false

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 40) { // Increased spacing for iPad
                    Spacer(minLength: 60)

                    Text("Iniciar Sesión")
                        .font(.system(size: 60, weight: .bold)) // Larger font size
                        .greenTitle() // Apply your custom title style
                        .padding(.top, 40)

                    Image("Logo") // Ensure this asset exists
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geo.size.width * 0.5, 300), height: min(geo.size.width * 0.5, 300))
                        .padding(.bottom, 30)
                        // .foregroundColor(Color.verdeOscuro) // Uncomment if needed

                    VStack(spacing: 25) { // Increased spacing between fields
                        TextField("Correo electrónico", text: $email)
                            .font(.title2) // Larger standard font size
                            .padding(20) // Increased padding
                            .background(Color.grisFondo) // Use custom background color
                            .cornerRadius(15) // Slightly larger radius
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        SecureField("Contraseña", text: $password)
                            .font(.title2) // Larger standard font size
                            .padding(20) // Increased padding
                            .background(Color.grisFondo) // Use custom background color
                            .cornerRadius(15) // Slightly larger radius
                            .textContentType(.password)
                    }
                    .padding(.horizontal, max(geo.size.width * 0.15, 60)) // Relative padding

                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.headline) // Larger error font
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .padding(.top, 5)
                    }

                    Button {
                        didAttemptLogin = true
                        authViewModel.login(email: email, password: password)
                    } label: {
                        Text("Ingresar")
                            .font(.title2.weight(.semibold)) // Larger button text
                            .foregroundColor(.white) // White text
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15) // Taller button
                    }
                    .background(Color.verdeBoton) // Use custom button color
                    .cornerRadius(25) // Your corner radius
                    .padding(.horizontal, max(geo.size.width * 0.25, 100))
                    .padding(.top, 20)

                    Spacer(minLength: 40)
                }
                .frame(width: geo.size.width)
                .frame(minHeight: geo.size.height)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
        }
        .navigationTitle("Login")
        .onChange(of: authViewModel.isAuthenticated) { oldValue, newValue in
            print("LoginView onChange: isAuthenticated changed from \(oldValue) to \(newValue)")
            if !oldValue && newValue && didAttemptLogin {
                print("Login successful via this view, dismissing...")
                dismiss()
            }
        }
        .onAppear {
            didAttemptLogin = false
        }
    }
}

#Preview {
    NavigationStack{
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
