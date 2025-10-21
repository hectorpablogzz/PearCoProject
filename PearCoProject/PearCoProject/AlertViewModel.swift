//
//  AlertViewModel.swift
//  PearCoProject
//
//  Created by Alumno on 01/10/25.
//

import Foundation
import SwiftData

@Model
class Alert: Identifiable, ObservableObject, Decodable {
    var idalert: UUID
    var category: String
    var title: String
    var action: String
    var type: String
    var date: Date
    var isCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case idalert
        case category
        case title
        case action
        case type
        case date
        case isCompleted
    }
    
    init(idalert: UUID, category: String, title: String, action: String, type: String, date: Date, isCompleted: Bool) {
        self.idalert = idalert
        self.category = category
        self.title = title
        self.action = action
        self.type = type
        self.date = date
        self.isCompleted = isCompleted
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idalert = try container.decode(UUID.self, forKey: .idalert)
        category = try container.decode(String.self, forKey: .category)
        title = try container.decode(String.self, forKey: .title)
        action = try container.decode(String.self, forKey: .action)
        type = try container.decode(String.self, forKey: .type)
        date = try container.decode(Date.self, forKey: .date)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
}


@MainActor
class AlertViewModel: ObservableObject {
    @Published var alerts = [Alert]()
    @Published var groupedAlerts: [String: [Alert]] = [:]
    @Published var isLoading = true
    @Published var hasError = false
    
    func loadAPI(for date: Date? = nil) async {
        let userId = "18d7bd5e-d046-4e4f-9ef3-fe4c8a7877c7"
        guard let url = URL(string: "https://pearcoflaskapi.onrender.com/alerts?idusuario=\(userId)") else {
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let results = try decoder.decode([Alert].self, from: data)
            self.alerts = results
            self.isLoading = false
            
            if let date = date {
                groupAlerts(for: date)
            }
        } catch {
            print("Error cargando API: \(error)")
            self.isLoading = false
            self.hasError = true
        }
    }
    
    func groupAlerts(for date: Date) {
        let sameDay = alerts.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        self.groupedAlerts = Dictionary(grouping: sameDay, by: { $0.category })
    }
    
    func toggleCompletion(alert: Alert) async {
        guard let url = URL(string: "https://pearcoflaskapi.onrender.com/alerts/complete") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "idalerta": alert.idalert.uuidString,
            "isCompleted": !alert.isCompleted
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                alert.isCompleted.toggle()
            } else {
                print("Error actualizando alerta en servidor")
            }
        } catch {
            print("Error de red: \(error)")
        }
    }
    
    func delete(alert: Alert) async {
        guard let url = URL(string: "https://pearcoflaskapi.onrender.com/alerts/\(alert.idalert.uuidString)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                alerts.removeAll { $0.idalert == alert.idalert }
                if var alertsInCategory = groupedAlerts[alert.category] {
                    alertsInCategory.removeAll { $0.idalert == alert.idalert }
                    
                    if alertsInCategory.isEmpty {
                        groupedAlerts.removeValue(forKey: alert.category)
                    } else {
                        groupedAlerts[alert.category] = alertsInCategory
                    }
                }
                
            } else {
                print("Error eliminando alerta en el servidor")
            }
        } catch {
            print("Error de red: \(error)")
        }
    }
    
    func canDelete(alert: Alert) -> Bool {
        return alert.isCompleted
    }

}
