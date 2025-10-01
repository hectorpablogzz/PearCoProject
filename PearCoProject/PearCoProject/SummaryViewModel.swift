//
//  SummaryViewModel.swift
//  
//
//  Created by Alumno on 30/09/25.
//

import Foundation

@MainActor
final class SummaryViewModel: ObservableObject {
    @Published var datos: [WeatherData] = []
    @Published var isLoading: Bool = false
    @Published var error: String?

    private let baseURLString = "https://pearcoflaskapi.onrender.com"

    // ⬇️ Nuevo: permite inyectar datos en previews (sin red)
    init(previewData: [WeatherData] = []) {
        self.datos = previewData
    }

    func fetch() async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            guard let url = URL(string: baseURLString + "/summary") else {
                throw URLError(.badURL)
            }
            var req = URLRequest(url: url)
            req.httpMethod = "GET"
            req.timeoutInterval = 20

            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let decoded = try JSONDecoder().decode([WeatherData].self, from: data)
            self.datos = decoded
        } catch {
            self.error = error.localizedDescription
        }
    }

    var ultimo: WeatherData? { datos.last }

    var barrasUltimo: [(String, Double)] {
        guard let u = ultimo else { return [] }
        var res: [(String, Double)] = []
        func push(_ name: String, _ v: Double?) {
            guard let v = v else { return }
            res.append((name, normaliza(v)))
        }
        push("Roya", u.royaRisk)
        push("Broca", u.brocaRisk)
        push("Ojo de gallo", u.ojoRisk)
        push("Antracnosis", u.antracRisk)
        return res
    }

    private func normaliza(_ v: Double) -> Double {
        let x = v > 1 ? v / 100.0 : v
        return min(max(x, 0), 1)
    }
}
