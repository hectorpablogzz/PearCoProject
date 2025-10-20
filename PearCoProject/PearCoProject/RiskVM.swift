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
    var loading = false
    var error: String?

    private let service: RiskService
    init(service: RiskService) { self.service = service }

    func load(regionID: String, year: Int) async {
        loading = true; defer { loading = false }
        do {
            monthly = try await service.fetchYear(regionID: regionID, year: year)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
