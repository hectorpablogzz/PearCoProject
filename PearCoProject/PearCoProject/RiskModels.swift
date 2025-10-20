//
//  RiskModels.swift
//  PearCoProject
//
//  Created by Alumno on 20/10/25.
//

import Foundation

struct RiskItem: Codable, Identifiable {
    var id: String { disease }
    let disease: String
    let risk: Double
    let category: String
    let uncertainty: Double
    let drivers: [String]
}

struct RiskMonthResponse: Codable {
    let region_id: String
    let year: Int
    let month: Int
    let results: [RiskItem]
}
