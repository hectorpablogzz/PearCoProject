//
//  ParcelaViewModel.swift
//  PearCoProject
//

import Foundation

@MainActor
class ParcelaViewModel: ObservableObject {
    @Published var parcelas: [Parcela] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    var hasError: Bool { errorMessage != nil }

    // --- USANDO URL DE RENDER ---
    private let baseURL = "https://pearcoflaskapi.onrender.com/parcelas"

    // MARK: - Fetch Parcelas
    func fetchParcelas() async {
        isLoading = true
        errorMessage = nil
        print("🚀 Fetching parcelas...")

        guard let url = URL(string: baseURL) else {
            errorMessage = "URL base inválida: \(baseURL)"; isLoading = false
            print("🚨 Error: URL base inválida - \(baseURL)"); return
        }

        do {
            print("📡 Enviando petición GET a \(baseURL)...")
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                 errorMessage = "Respuesta inválida (no es HTTP)."; isLoading = false
                 print("🚨 Error: Respuesta no es HTTP"); return
            }
            print("📬 GET Response: Código \(httpResponse.statusCode)") // Log status code

            // --- MANEJO DE ERRORES HTTP (Incluye 500) ---
            guard httpResponse.statusCode == 200 else {
                // --- ATTEMPT TO GET ERROR DETAILS FROM RESPONSE BODY ---
                var detailedError = "Error del servidor (\(httpResponse.statusCode))." // Default message
                // 1. Try reading raw data as String
                if let rawErrorString = String(data: data, encoding: .utf8), !rawErrorString.isEmpty {
                    print("📄 Raw Error Response Data (Status \(httpResponse.statusCode)): \(rawErrorString)")
                    detailedError += " Respuesta: \(rawErrorString)" // Append raw string to error
                } else {
                    print("⚠️ No raw error data received or unreadable.")
                }
                // 2. Try decoding as ParcelaListResponse (maybe it contains {"success":false, "error":"..."})
                let errorResponse = try? JSONDecoder().decode(ParcelaListResponse.self, from: data)
                if let apiErrorMessage = errorResponse?.error, !apiErrorMessage.isEmpty {
                    print("❌ API Error Message Decoded: \(apiErrorMessage)")
                    detailedError = "Error API (\(httpResponse.statusCode)): \(apiErrorMessage)" // Prioritize decoded API error
                }
                // --------------------------------------------------------

                errorMessage = detailedError // Set the published error message
                isLoading = false
                print("❌ Fetch failed with status code \(httpResponse.statusCode). Error set to: \(errorMessage!)")
                return // Stop execution
            }

            // --- SUCCESS PATH (Status Code 200) ---
            guard !data.isEmpty else {
                errorMessage = "Respuesta vacía (Código 200)."; isLoading = false; print(errorMessage!);
                self.parcelas = [] // Treat empty success as an empty list
                return
            }
            if let responseString = String(data: data, encoding: .utf8) { print("📄 Datos (GET /parcelas - raw): \(responseString)") }

            // Decode using ParcelaListResponse (expects {"success": true, "data": [...]})
            let decodedResponse = try JSONDecoder().decode(ParcelaListResponse.self, from: data)
            print("✅ Decodificado (GET /parcelas): success=\(decodedResponse.success)")

            if decodedResponse.success {
                self.parcelas = decodedResponse.data
                print("🌱 \(self.parcelas.count) parcelas cargadas.")
            } else {
                // Handle case where status is 200 but success: false
                errorMessage = decodedResponse.error ?? "Error API al obtener parcelas (success: false)."
                print("❌ API Error (GET /parcelas): \(errorMessage!)")
                self.parcelas = [] // Clear parcelas on API error
            }
        } catch let error as DecodingError {
            print("🚨 ERROR DE DECODIFICACIÓN (GET /parcelas): \(error)")
            errorMessage = "Error al procesar datos de parcelas: \(error.localizedDescription)"
            logDecodingError(error) // Log detailed decoding error
        } catch {
            print("🚨 ERROR DE RED/CONEXIÓN (GET /parcelas): \(error)")
            errorMessage = "Error de conexión al obtener parcelas: \(error.localizedDescription)."
        }
        isLoading = false
    }

    // --- Funciones create, update, delete (permanecen igual que antes) ---

    // MARK: - Create Parcela
    func createParcela(nombre: String, hectareas: Double, tipo: String,
                       estado: String, municipio: String, latitud: Double, longitud: Double) async {
        errorMessage = nil; print("🚀 Creando parcela: \(nombre)...")
        guard let url = URL(string: baseURL) else { return }
        let nuevaParcela: [String: Any] = [
            "nombre": nombre, "hectareas": hectareas, "tipo": tipo,
            "ubicacion": ["estado": estado, "municipio": municipio, "latitud": latitud, "longitud": longitud]
        ]
        do {
            var req = URLRequest(url: url); req.httpMethod = "POST"
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = try JSONSerialization.data(withJSONObject: nuevaParcela)
            print("📡 POST \(baseURL)...")
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse else { errorMessage = "No HTTP (POST)"; print("🚨 No HTTP"); return }
            print("📬 POST Response: \(http.statusCode)")
            guard http.statusCode == 201 else {
                 let errorResponse = try? JSONDecoder().decode(ParcelaResponse.self, from: data)
                 errorMessage = errorResponse?.error ?? "Error creando (\(http.statusCode))."
                if let errStr = String(data: data, encoding: .utf8) { print("   Error raw: \(errStr)") }
                return
            }
            if let responseString = String(data: data, encoding: .utf8) { print("📄 Datos (POST /parcelas - raw): \(responseString)") }
            let decodedResponse = try JSONDecoder().decode(ParcelaResponse.self, from: data)
            print("✅ Decodificado (POST /parcelas): success=\(decodedResponse.success)")
            if decodedResponse.success {
                self.parcelas.append(decodedResponse.data); print("✅ Parcela '\(decodedResponse.data.nombre)' creada.")
            } else {
                errorMessage = decodedResponse.error ?? "API error creando (success: false)."; print("❌ API Error: \(errorMessage!)")
            }
        } catch let error as DecodingError {
             print("🚨 ERROR DE DECODIFICACIÓN (POST /parcelas): \(error)"); errorMessage = "Error procesando respuesta: \(error.localizedDescription)"; logDecodingError(error)
        } catch { print("🚨 ERROR (POST /parcelas): \(error)"); errorMessage = "Error al crear: \(error.localizedDescription)" }
    }

    // MARK: - Update Parcela
    func updateParcela(id: String, nombre: String, hectareas: Double, tipo: String,
                       estado: String, municipio: String, latitud: Double, longitud: Double) async {
         errorMessage = nil; let urlString = "\(baseURL)/\(id)"; print("🚀 Actualizando parcela \(id)...")
         guard let url = URL(string: urlString) else { errorMessage = "Invalid URL (PUT)"; print("🚨 Bad URL"); return }
         let datos: [String: Any] = [
             "nombre": nombre, "hectareas": hectareas, "tipo": tipo,
             "ubicacion": ["estado": estado, "municipio": municipio, "latitud": latitud, "longitud": longitud]
         ]
         do {
             var req = URLRequest(url: url); req.httpMethod = "PUT"
             req.addValue("application/json", forHTTPHeaderField: "Content-Type")
             req.httpBody = try JSONSerialization.data(withJSONObject: datos)
             print("📡 PUT \(urlString)...")
             let (data, response) = try await URLSession.shared.data(for: req)
             guard let http = response as? HTTPURLResponse else { errorMessage = "No HTTP (PUT)"; print("🚨 No HTTP"); return }
             print("📬 PUT Response: \(http.statusCode)")
             guard http.statusCode == 200 else {
                  let errorResponse = try? JSONDecoder().decode(ParcelaResponse.self, from: data)
                  errorMessage = errorResponse?.error ?? "Error actualizando (\(http.statusCode))."
                 if let errStr = String(data: data, encoding: .utf8) { print("   Error raw: \(errStr)") }
                 return
             }
              if let responseString = String(data: data, encoding: .utf8) { print("📄 Datos (PUT /parcelas/\(id) - raw): \(responseString)") }
             let decodedResponse = try JSONDecoder().decode(ParcelaResponse.self, from: data)
              print("✅ Decodificado (PUT /parcelas/\(id)): success=\(decodedResponse.success)")
             if decodedResponse.success {
                 if let index = self.parcelas.firstIndex(where: { $0.idParcela == id }) {
                     self.parcelas[index] = decodedResponse.data; print("✅ Parcela ID '\(id)' actualizada localmente.")
                 } else { await fetchParcelas() } // Recarga si no la encuentra
             } else { errorMessage = decodedResponse.error ?? "API error updating."; print("❌ API Error: \(errorMessage!)") }
          } catch let error as DecodingError {
               print("🚨 ERROR DE DECODIFICACIÓN (PUT /parcelas): \(error)"); errorMessage = "Error procesando respuesta: \(error.localizedDescription)"; logDecodingError(error)
          } catch { print("🚨 ERROR (PUT /parcelas/\(id)): \(error)"); errorMessage = "Error al actualizar: \(error.localizedDescription)" }
     }


    // MARK: - Delete Parcela
    func deleteParcela(id: String) async {
        errorMessage = nil; let urlString = "\(baseURL)/\(id)"; print("🚀 Eliminando parcela \(id)...")
        guard let url = URL(string: urlString) else { errorMessage = "Invalid URL (DELETE)"; print("🚨 Bad URL"); return }
        do {
            var req = URLRequest(url: url); req.httpMethod = "DELETE"
            print("📡 DELETE \(urlString)...")
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse else { errorMessage = "No HTTP (DELETE)"; print("🚨 No HTTP"); return }
            print("📬 DELETE Response: \(http.statusCode)")
            guard http.statusCode == 200 else {
                let errorResponse = try? JSONDecoder().decode(DeleteResponse.self, from: data)
                errorMessage = errorResponse?.error ?? "Error eliminando (\(http.statusCode))."
                if http.statusCode == 409 { errorMessage = "No se puede eliminar: Parcela asignada."} // Specific msg for conflict
                print("❌ Error deleting: \(errorMessage!)")
                if let rawErr = String(data: data, encoding: .utf8) { print("   Raw error: \(rawErr)")}
                return
            }
            parcelas.removeAll { $0.idParcela == id }; print("✅ Parcela ID '\(id)' eliminada localmente.")
        } catch let error as DecodingError {
             print("🚨 ERROR DE DECODIFICACIÓN (DELETE /parcelas): \(error)"); errorMessage = "Error procesando respuesta: \(error.localizedDescription)"; logDecodingError(error)
        } catch { print("🚨 ERROR (DELETE /parcelas/\(id)): \(error)"); errorMessage = "Error al eliminar: \(error.localizedDescription)" }
    }

    // --- Helper para Loguear Errores de Decodificación ---
    private func logDecodingError(_ error: DecodingError) {
        // (El mismo código de logDecodingError que te di antes)
        // ...
         switch error {
         case .keyNotFound(let key, let context): print("   - Decoding Error: Falta clave '\(key.stringValue)'. Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
         case .typeMismatch(let type, let context): print("   - Decoding Error: Tipo incorrecto para '\(context.codingPath.last?.stringValue ?? "?")'. Esperado \(type). Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
         case .valueNotFound(let type, let context): print("   - Decoding Error: Valor nulo/faltante para '\(context.codingPath.last?.stringValue ?? "?")'. Esperado \(type). Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
         case .dataCorrupted(let context): print("   - Decoding Error: JSON malformado. Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
         @unknown default: print("   - Decoding Error: Desconocido.")
         }
         print("     Debug Description: \(error.localizedDescription)") // General description is often helpful too
    }

} // Fin de la clase ParcelaViewModel

// MARK: - Extensión para Previews (Fuera de la clase principal)
extension ParcelaViewModel {
     static func previewWithData() -> ParcelaViewModel {
         let vm = ParcelaViewModel()
         vm.parcelas = [ /* ... tus datos de ejemplo ... */ ]
         vm.isLoading = false; vm.errorMessage = nil; return vm
     }
 }
