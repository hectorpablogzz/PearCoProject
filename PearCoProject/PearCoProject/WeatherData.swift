//
//  WeatherData.swift
//  PearCoProject
//
//  Created by Héctor Pablo González on 09/09/25.
//

import Foundation

struct WeatherData: Identifiable, Decodable {
    var year: Int
    var month: String
    var temperature: Double
    var rain: Double
    var royaRisk: Double
    var brocaRisk: Double
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case year
        case month
        case temperature
        case rain
        case royaRisk
        case brocaRisk
    }
}
