//
//  Report.swift
//  PearCoProject
//
//  Created by Héctor Pablo González on 09/09/25.
//

import Foundation

struct Report: Identifiable, Decodable {
    var id = UUID()
    var title: String
    var message: String
    var data: [WeatherData]
    
    enum CodingKeys: String, CodingKey {
        case title
        case message
        case data
    }
    
}
