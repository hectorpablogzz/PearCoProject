//
//  PearCoProjectApp.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI
import SwiftData

@main
struct PearCoProjectApp: App {
    
    @StateObject private var predictionStatus = PredictionStatus()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(predictionStatus)
                .modelContainer(for: CaficultorModel.self)
        }
    }
}


