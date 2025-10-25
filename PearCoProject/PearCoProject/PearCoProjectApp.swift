//
//  PearCoProjectApp.swift
//  PearCoProject
//

import SwiftUI
import SwiftData // Keep if needed

@main
struct PearCoProjectApp: App {

    // Create the shared AuthViewModel instance
    @StateObject private var authViewModel = AuthViewModel()

    // Keep PredictionStatus if needed elsewhere
    @StateObject private var predictionStatus = PredictionStatus()

    var body: some Scene {
        WindowGroup {
            // Root view is NavigationStack containing ContentView
            NavigationStack {
                ContentView() // Always start with ContentView
            }
            // Make ViewModels available to all child views
            .environmentObject(authViewModel)
            .environmentObject(predictionStatus)
            // Apply model container if needed globally
            .modelContainer(for: CaficultorModel.self)
        }
    }
}
