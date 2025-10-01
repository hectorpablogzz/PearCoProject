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

    // Reemplaza por tu dominio en Render, p. ej.: "https://kaapeh-api.onrender.com"
    private let baseURLString = "(aquí va el link)"

    /// Llama a GET {base}/summary y decodifica [WeatherData]
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

    // MARK: - Helpers para tu UI

    /// Último registro disponible (p.ej. el mes más reciente)
    var ultimo: WeatherData? { datos.last }

    /// Barras (nombre, valor 0–1) listas para graficar usando el último registro.
    /// Si alguno viene nil, se omite. Si viene 0–100, se normaliza a 0–1.
    var barrasUltimo: [(String, Double)] {
        guard let u = ultimo else { return [] }
        var res: [(String, Double)] = []

        func push(_ name: String, _ v: Double?) {
            guard let v = v else { return }
            res.append((name, normaliza(v)))
        }

        push("Roya", u.royaRisk)
        push("Broca", u.brocaRisk)
        push("Ojo de gallo", u.ojoGalloRisk)
        push("Antracnosis", u.antracnosisRisk)
        return res
    }

    /// (Opcional) Todas las barras por registro, por si luego quieres histórico
    var barrasHistoricas: [[(String, Double)]] {
        datos.map { d in
            [
                ("Roya", d.royaRisk),
                ("Broca", d.brocaRisk),
                ("Ojo de gallo", d.ojoGalloRisk),
                ("Antracnosis", d.antracnosisRisk)
            ]
            .compactMap { name, v in
                guard let v = v else { return nil }
                return (name, normaliza(v))
            }
        }
    }

    /// Convierte 0–100 → 0–1; si ya está en 0–1, lo deja.
    private func normaliza(_ v: Double) -> Double {
        let x = v > 1 ? v / 100.0 : v
        return min(max(x, 0), 1)
    }
}
