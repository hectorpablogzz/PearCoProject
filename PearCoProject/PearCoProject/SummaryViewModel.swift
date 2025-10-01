//
//  SummaryViewModel.swift
//  
//
//  Created by Alumno on 30/09/25.
//

import Foundation

@MainActor
final class SummaryViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    // cache del objeto plano (del día)
    @Published private(set) var flat: SummaryFlat?

    // Cambia esto por tu dominio base si lo prefieres; aquí ya va completo
    private let summaryURLString = "https://pearcoflaskapi.onrender.com/summary"

    struct SummaryFlat: Decodable {
        let royaRisk: Double
        let brocaRisk: Double
        let ojoRisk: Double
        let antracRisk: Double
    }

    // Para previews/tests sin red
    init(previewFlat: SummaryFlat? = nil) {
        self.flat = previewFlat
    }

    // GET /summary → decodifica SummaryFlat (riesgos del día)
    func fetch() async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            guard let url = URL(string: summaryURLString) else { throw URLError(.badURL) }
            let (data, resp) = try await URLSession.shared.data(from: url)
            guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let decoded = try JSONDecoder().decode(SummaryFlat.self, from: data)
            self.flat = decoded
        } catch {
            self.error = error.localizedDescription
        }
    }

    // Barras del día (0–1). Mantengo el nombre para no romper tu HomeView si usas `barrasUltimo`.
    var barrasUltimo: [(String, Double)] { barrasDia }

    var barrasDia: [(String, Double)] {
        guard let f = flat else { return [] }
        return [
            ("Roya", normaliza(f.royaRisk)),
            ("Broca", normaliza(f.brocaRisk)),
            ("Ojo de gallo", normaliza(f.ojoRisk)),
            ("Antracnosis", normaliza(f.antracRisk))
        ]
    }

    // 0–100 → 0–1 (si ya viene 0–1, se respeta)
    private func normaliza(_ v: Double) -> Double {
        let x = v > 1 ? v / 100.0 : v
        return min(max(x, 0), 1)
    }
}
