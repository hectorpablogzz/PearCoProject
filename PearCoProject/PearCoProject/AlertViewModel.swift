//
//  AlertViewModel.swift
//  PearCoProject
//
//  Created by Alumno on 01/10/25.
//

import Foundation

class Alert: Identifiable, Decodable {
    var id = UUID()
    var category: String
    var title: String
    var action: String
    var date: Date
    var isCompleted: Bool = false
    
    enum CodingKeys : String, CodingKey {
        case category
        case title
        case action
        case date
        case isCompleted
    }
    
}

class AlertViewModel: ObservableObject {
    @Published var alerts = [Alert]()
    @Published var isLoading = true
    @Published var hasError = false
    
    init() {
        Task {
            await loadAPI()
        }
    }
    
    @MainActor
    func loadAPI() async {
        guard let url = URL(string: "http://10.22.215.30:5000/alerts") else {
            print("URL inválida")
            self.isLoading = false
            self.hasError = true
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                self.isLoading = false
                self.hasError = true
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let results = try decoder.decode([Alert].self, from: data)
            self.alerts = results
            self.isLoading = false
        } catch {
            print("Error cargando API: \(error)")
            self.isLoading = false
            self.hasError = true
        }
    }
}
