//
//  RiskService.swift
//  PearCoProject
//
//  Created by Alumno on 20/10/25.
//

import Foundation
import SwiftUI

protocol RiskService {
    func fetchYear(regionID: String, year: Int) async throws -> [RiskMonthResponse]
}

final class RiskAPIClient: RiskService {
    let baseURL: URL
    init(baseURL: URL) { self.baseURL = baseURL }

    func fetchYear(regionID: String, year: Int) async throws -> [RiskMonthResponse] {
        let url = baseURL.appendingPathComponent("risk_series/\(regionID)/\(year)")
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([RiskMonthResponse].self, from: data)
    }
}

// MARK: - EnvironmentKey para inyectar el servicio sin tocar ContentView
private struct RiskServiceKey: EnvironmentKey {
    static let defaultValue: RiskService = RiskAPIClient(
        baseURL: URL(string: "https://TU_API/")!
    )
}
extension EnvironmentValues {
    var riskService: RiskService {
        get { self[RiskServiceKey.self] }
        set { self[RiskServiceKey.self] = newValue }
    }
}
