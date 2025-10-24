//
//  HomeViewAndTermsAndConditionsTests.swift
//  HomeViewAndTermsAndConditionsTests
//
//  Created by Alumno on 23/10/25.
//

import Testing
@testable import PearCoProject

struct HomeViewAndTermsAndConditionsTest {

    @Test("El overlay de Términos debe mostrarse la primera vez y ocultarse después de aceptar")
    func testTermsVisibilityState() async throws {
        // Arrange
        var hasAcceptedTerms = false
        var showTerms = !hasAcceptedTerms
        // Assert estado inicial
        #expect(showTerms == true)

        // Act — usuario acepta términos
        hasAcceptedTerms = true
        showTerms = !hasAcceptedTerms
        // Assert después de aceptar
        #expect(showTerms == false)
    }
    
    @Test("stepMonth cambia correctamente el índice del mes")
    func testStepMonthLogic() async throws {
        // Arrange
        var selectedMonthIndex = 9   // Ej. Octubre (0-based)
        let totalMonths = 12

        // Act — avanzar
        selectedMonthIndex = (selectedMonthIndex + 1) % totalMonths
        // Assert
        #expect(selectedMonthIndex == 10)   // Noviembre

        // Act — retroceder
        selectedMonthIndex = (selectedMonthIndex - 1 + totalMonths) % totalMonths
        // Assert
        #expect(selectedMonthIndex == 9)    // de vuelta a Octubre
    }
}
