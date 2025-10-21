//
//  RiskVM.swift
//  PearCoProject
//
//  Created by Alumno on 20/10/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class RiskVM {
    var monthly: [RiskMonthResponse] = []
    var isLoading: Bool = false
    var error: String?

    // Cambia por tu dominio base
    private let baseURL = "https://pearcoflaskapi.onrender.com/"

    init(previewMonthly: [RiskMonthResponse]? = nil) {
        if let m = previewMonthly { self.monthly = m }
    }

    func fetchMonthly(regionID: String, year: Int) async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            guard let url = URL(string: "\(baseURL)risk_series/\(regionID)/\(year)") else {
                throw URLError(.badURL)
            }
            let (data, resp) = try await URLSession.shared.data(from: url)
            guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let decoded = try JSONDecoder().decode([RiskMonthResponse].self, from: data)
            self.monthly = decoded.sorted { $0.month < $1.month } // ← asegura orden 1..12
        } catch {
            self.error = error.localizedDescription
        }
    }
}
