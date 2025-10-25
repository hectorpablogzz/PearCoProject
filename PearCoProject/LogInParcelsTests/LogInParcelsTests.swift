//
//  PearCoTests.swift // Or your chosen test file name
//  YourAppTests    // Ensure this matches your test target name
//

import Testing // Use the Swift Testing framework
import SwiftUI // Often needed when dealing with ViewModels/Models

// Import your main app module to access its code
// !!! REPLACE 'PearCoProject' with your actual app module name !!!
@testable import PearCoProject

@MainActor // Mark struct as MainActor because ViewModels require it
struct PearCoTests {

    // MARK: - AuthViewModel Tests

    @Test("AuthViewModel - Estado Inicial") // Test 1
    func testAuthViewModel_InitialState_IsLoggedOut() throws {
        // Arrange: Create a fresh instance
        let viewModel = AuthViewModel()

        // Act: No action needed for initial state

        // Assert: Check default values using #expect
        #expect(viewModel.isAuthenticated == false, "Initial state should not be authenticated")
        #expect(viewModel.currentUser == nil, "Initial current user should be nil")
        #expect(viewModel.errorMessage == nil, "Initial error message should be nil")
        #expect(viewModel.idUser == nil, "Initial user ID should be nil")
    }

    @Test("AuthViewModel - Login Falla con Credenciales Vacías") // Test 2
    func testAuthViewModel_LoginEmptyCredentials_SetsError() throws {
        // Arrange
        let viewModel = AuthViewModel()
        let expectedError = "Por favor, ingrese correo y contraseña."

        // Act: Call login with empty strings
        viewModel.login(email: "", password: "")

        // Assert: Check that state reflects failure and error message
        #expect(viewModel.isAuthenticated == false, "Should not authenticate with empty credentials")
        #expect(viewModel.errorMessage != nil, "Error message should be set")
        #expect(viewModel.errorMessage == expectedError, "Error message should match expected text. Got: \(viewModel.errorMessage ?? "nil")")
        #expect(viewModel.currentUser == nil, "Current user should remain nil")
    }

    @Test("AuthViewModel - Logout Resetea Estado") // Test 3 (Bonus)
    func testAuthViewModel_Logout_ResetsProperties() throws {
        // Arrange: Simulate a logged-in state
        let viewModel = AuthViewModel()
        viewModel.isAuthenticated = true
        // Use the correct User initializer (make sure it matches your User.swift)
        viewModel.currentUser = User(idusuario: "test-id", nombre: "Test", apellido: "User", correo: "test@test.com", idparcela: "p-id")
        viewModel.idUser = "test-id"
        viewModel.errorMessage = "Some previous error" // Simulate an existing error

        // Act: Call the logout function
        viewModel.logout()

        // Assert: Check if all relevant properties were reset
        #expect(viewModel.isAuthenticated == false, "isAuthenticated should be false after logout")
        #expect(viewModel.currentUser == nil, "currentUser should be nil after logout")
        #expect(viewModel.idUser == nil, "idUser should be nil after logout")
        #expect(viewModel.errorMessage == nil, "errorMessage should be cleared after logout")
    }


    // MARK: - ParcelaViewModel Tests

    @Test("ParcelaViewModel - Estado Inicial") // Test 4 (Bonus)
    func testParcelaViewModel_InitialState_IsEmptyAndNoError() throws {
        // Arrange: Create a fresh instance
        let viewModel = ParcelaViewModel()

        // Act: No action needed

        // Assert: Check default values
        #expect(viewModel.parcelas.isEmpty == true, "Initial parcelas array should be empty")
        #expect(viewModel.isLoading == false, "Initial isLoading should be false")
        #expect(viewModel.errorMessage == nil, "Initial errorMessage should be nil")
        #expect(viewModel.hasError == false, "Initial hasError should be false")
    }

    // Note: Testing async functions like fetchParcelas requires mocking URLSession
    // or using network testing libraries, which is more advanced than typically
    // required for basic unit test assignments. Sticking to initial state
    // and synchronous logic (like input validation if you add it) is safer.

} // End of test struct
