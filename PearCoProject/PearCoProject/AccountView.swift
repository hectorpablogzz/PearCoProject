//
//  AccountView.swift
//  PearCoProject
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var parcelaViewModel = ParcelaViewModel()
    @State private var showParcela = false
    @State private var showConfig = false

    var body: some View {
        HStack (spacing:0){
            GeometryReader { geo in
                ZStack {
                    ScrollView {
                        // Main VStack within ScrollView
                        VStack(spacing: 30) { // Spacing between sections

                            // --- Header ---
                            Text("Perfil Caficultor")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color.verdeOscuro)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 30)

                            // --- CONDITIONAL CONTENT ---
                            if authViewModel.isAuthenticated {
                                // --- If Authenticated ---
                                authenticatedSection(geo: geo) // Pass geometry
                            } else {
                                // --- If Not Authenticated ---
                                loginPromptSection(geo: geo) // Pass geometry
                            }

                            // Spacer to push content up if ScrollView content is short
                            // Remove if you want content centered vertically when short
                            // Spacer(minLength: 30) //<- Might not be needed if logout button uses Spacer

                        } // End Main VStack
                        .frame(width: geo.size.width) // Ensure VStack uses width
                        // Add padding at the bottom to ensure content doesn't sit right at the edge
                        .padding(.bottom, 50)

                    } // End ScrollView
                    .background(Color.white) // Background for scrollable content

                    // --- Optional Microphone Button ---
                    /*
                    MicrophoneButton(color: Color.verdeOscuro) ...
                    */

                } // End ZStack
            } // End GeometryReader
        } // End HStack
        .greenSidebar()
    }

    // --- Subview: Authenticated Section ---
    @ViewBuilder
    private func authenticatedSection(geo: GeometryProxy) -> some View {
        // This VStack now contains profile info, parcelas, config AND the logout button Spacer
        VStack(spacing: 30) { // Spacing between profile/parcela/config/button group

            // Group for Profile Info + Parcelas + Config
            VStack(spacing: 30){ // Spacing within the main content group
                // Profile info subview
                authenticatedProfileInfo(geo: geo)

                // Parcela section subview
                parcelaSection(geo: geo)

                // Configuration Section (Only shown when authenticated)
                configurationSection(geo: geo)
            }

            Spacer(minLength: 40) // <-- PUSHES LOGOUT BUTTON DOWN

            // Logout button subview
            logoutButton(geo: geo)

        } // End authenticatedSection VStack
    }


    // --- Subview: Profile Info ---
    @ViewBuilder
    private func authenticatedProfileInfo(geo: GeometryProxy) -> some View {
         VStack(spacing: 8) {
             Image("agricultor_ejemplo")
                 .resizable()
                 .scaledToFill()
                 .frame(width: geo.size.width * 0.35, height: geo.size.width * 0.35)
                 .clipShape(Circle())
                 .overlay(Circle().stroke(Color.black, lineWidth: 1))

             Text("\(authViewModel.currentUser?.nombre ?? "Nombre") \(authViewModel.currentUser?.apellido ?? "Apellido")")
                 .font(.system(size: geo.size.width * 0.05, weight: .semibold))
                 .lineLimit(1)

             Text(authViewModel.currentUser?.correo ?? "correo@ejemplo.com")
                 .foregroundColor(.gray)
                 .font(.system(size: geo.size.width * 0.04))
                 .lineLimit(1)
         }
         .padding(.bottom, 10) // Reduced bottom padding slightly
    }

    // --- Subview: Parcela Section ---
    @ViewBuilder
    private func parcelaSection(geo: GeometryProxy) -> some View {
        VStack(spacing: 12) {
             DisclosureGroup(isExpanded: $showParcela) {
                 VStack(alignment: .leading, spacing: 10) {
                     NavigationLink {
                         ParcelaListView().environmentObject(parcelaViewModel)
                     } label: {
                         HStack {
                             Image(systemName: "leaf.fill"); Text("Ver / Administrar Parcelas"); Spacer(); Image(systemName: "chevron.right")
                         }
                         .foregroundColor(Color.verdeOscuro)
                         .font(.system(size: geo.size.width * 0.045))
                     }
                 }
                 .padding(.top, 10).frame(maxWidth: .infinity, alignment: .leading)
             } label: {
                 Text("Parcela de cultivo")
                     .font(.system(size: geo.size.width * 0.05, weight: .semibold))
                     .foregroundColor(.black)
                     .frame(maxWidth: .infinity, alignment: .leading)
             }
             .padding()
             .background(Color.grisFondo)
             .cornerRadius(12)
        }
        .padding(.horizontal, 40)
    }

    // --- Subview: Configuration Section ---
    @ViewBuilder
    private func configurationSection(geo: GeometryProxy) -> some View {
        VStack(spacing: 12){
            DisclosureGroup(isExpanded: $showConfig) {
                 VStack(alignment: .leading, spacing: 12) {
                     Button("Notificaciones") { /* Action */ }.buttonStyle(PlainButtonStyle()).foregroundColor(Color.verdeOscuro).font(.system(size: geo.size.width * 0.045)).frame(maxWidth: .infinity, alignment: .leading)
                     Divider()
                     Button("Preferencias") { /* Action */ }.buttonStyle(PlainButtonStyle()).foregroundColor(Color.verdeOscuro).font(.system(size: geo.size.width * 0.045)).frame(maxWidth: .infinity, alignment: .leading)
                     Divider()
                     Button("Soporte") { /* Action */ }.buttonStyle(PlainButtonStyle()).foregroundColor(Color.verdeOscuro).font(.system(size: geo.size.width * 0.045)).frame(maxWidth: .infinity, alignment: .leading)
                 }
                 .padding(.top, 5)
             } label: {
                 Text("Configuración").font(.system(size: geo.size.width * 0.05, weight: .semibold)).foregroundColor(.black).frame(maxWidth: .infinity, alignment: .leading)
             }
             .padding()
             .background(Color.grisFondo)
             .cornerRadius(12)
        }
         .padding(.horizontal, 40)
    }

    // --- Subview: Login Prompt Section ---
    @ViewBuilder
    private func loginPromptSection(geo: GeometryProxy) -> some View {
        VStack(spacing: 20) {
             Image(systemName: "person.crop.circle.badge.questionmark").resizable().scaledToFit().frame(width: geo.size.width * 0.3).foregroundColor(.gray)
             Text("Inicia sesión para administrar tu cuenta y parcelas.").font(.headline).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal, 40)
             NavigationLink { LoginView() }
             label: {
                 Text("Iniciar Sesión / Registrarse")
                     .foregroundColor(.white).font(.system(size: geo.size.width * 0.045, weight: .semibold))
                     .frame(maxWidth: .infinity).padding().background(Color.verdeBoton).cornerRadius(25)
             }
             .padding(.horizontal, 60)
        }
        .padding(.vertical, 30)
    }

     // --- Subview: Logout Button ---
     @ViewBuilder
     private func logoutButton(geo: GeometryProxy) -> some View {
         Button(role: .destructive) { // Role gives hint, but color is overridden
             print("Cerrar sesión presionado")
             authViewModel.logout()
         } label: {
             Text("Cerrar sesión")
                 .foregroundColor(.white)
                 .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                 .frame(maxWidth: .infinity)
                 .padding()
                 // --- COLOR CHANGED HERE ---
                 .background(Color.red) // Use standard red or your custom red
                 .cornerRadius(25)
         }
         // Removed buttonStyle(.borderedProminent) as background is set manually
         .padding(.horizontal, 60) // Original horizontal padding
         .padding(.bottom, 40) // Keep bottom padding
     }
}

// --- Preview Provider ---
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        // Authenticated
        NavigationStack { AccountView() }
        .environmentObject(AuthViewModel.previewAuthenticated())
        .previewDisplayName("Autenticado")

        // Not Authenticated
        NavigationStack { AccountView() }
        .environmentObject(AuthViewModel())
        .previewDisplayName("No Autenticado")
    }
}

// --- Preview Helper --- (Ensure User init matches User.swift)
extension AuthViewModel {
    static func previewAuthenticated() -> AuthViewModel {
        let vm = AuthViewModel(); vm.isAuthenticated = true
        vm.currentUser = User(idusuario: "prev-user", nombre: "Preview", apellido: "User", correo: "preview@test.com", idparcela: "prev-parc")
        vm.idUser = "prev-user"; return vm
    }
}
