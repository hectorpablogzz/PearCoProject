//
//  AllReportsViewModel.swift
//  PearCoProject
//
//  Created by Héctor Pablo González on 09/09/25.
//

import Foundation

@Observable
class AllReportsViewModel {
    
    var reports = [Report]()
    var isLoading = true
    var hasError = false
    
    init() {
        Task{
            do {
                try await loadAPI()
            }
            catch {
                self.isLoading = false
                self.hasError = true
                print("API Error")
            }
        }
    }
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    func loadAPI() async throws {
        // 1. URL
        guard let url = URL(string: "https://pearcoflaskapi.onrender.com/reports") else {
            print("Invalid URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            self.isLoading = false
            self.hasError = true
            print("error")
            return
        }
        
        let results = try JSONDecoder().decode([Report].self, from: data)
        
        self.isLoading = false
        
        //print(results)
        
        self.reports = results

    }
    
    

//    var reports: [Report] = [
//        .init(title: "Septiembre 2025", message: "Este mes hubo un aumento drástico en el riesgo del desarrollo de plagas y enfermedades debido al alto volumen de lluvia. El riesgo de roya subió a 95% y el riesgo de broca a 75%.", data: [
//            .init(year: 2025, month: "Apr", temperature: 21.133, rain: 50, royaRisk: 35, brocaRisk: 40),
//            .init(year: 2025, month: "May", temperature: 23.538, rain: 78.8, royaRisk: 50, brocaRisk: 60),
//            .init(year: 2025, month: "Jun", temperature: 22.883, rain: 179.8, royaRisk: 90, brocaRisk: 70),
//            .init(year: 2025, month: "Jul", temperature: 21.451, rain: 64.56, royaRisk: 45, brocaRisk: 50),
//            .init(year: 2025, month: "Aug", temperature: 22.564, rain: 63.2, royaRisk: 55, brocaRisk: 55),
//            .init(year: 2025, month: "Sep", temperature: 22.45, rain: 208.5, royaRisk: 95, brocaRisk: 75)
//        ]),
//        .init(title: "Agosto 2025", message: "Este mes hubo un ligero aumento en el riesgo del desarrollo de plagas y enfermedades debido al aumento de temperatura. El riesgo de roya subió a 55% y el riesgo de broca a 55%.", data: [
//            .init(year: 2025, month: "Mar", temperature: 19.072, rain: 25.4, royaRisk: 15, brocaRisk: 20),
//            .init(year: 2025, month: "Apr", temperature: 21.133, rain: 50, royaRisk: 35, brocaRisk: 40),
//            .init(year: 2025, month: "May", temperature: 23.538, rain: 78.8, royaRisk: 50, brocaRisk: 60),
//            .init(year: 2025, month: "Jun", temperature: 22.883, rain: 179.8, royaRisk: 90, brocaRisk: 70),
//            .init(year: 2025, month: "Jul", temperature: 21.451, rain: 64.56, royaRisk: 45, brocaRisk: 50),
//            .init(year: 2025, month: "Aug", temperature: 22.564, rain: 63.2, royaRisk: 55, brocaRisk: 55)
//        ]),
//        .init(title: "Julio 2025", message: "Este mes hubo una reducción drástica en el riesgo del desarrollo de plagas y enermedades debido a la reducción en el volumen de lluvia. El riesgo de roya bajó a 45% y el riesgo de broca a 50%.", data: [
//            .init(year: 2025, month: "Feb", temperature: 18.107, rain: 57.4, royaRisk: 20, brocaRisk: 30),
//            .init(year: 2025, month: "Mar", temperature: 19.072, rain: 25.4, royaRisk: 15, brocaRisk: 20),
//            .init(year: 2025, month: "Apr", temperature: 21.133, rain: 50, royaRisk: 35, brocaRisk: 40),
//            .init(year: 2025, month: "May", temperature: 23.538, rain: 78.8, royaRisk: 50, brocaRisk: 60),
//            .init(year: 2025, month: "Jun", temperature: 22.883, rain: 179.8, royaRisk: 90, brocaRisk: 70),
//            .init(year: 2025, month: "Jul", temperature: 21.451, rain: 64.56, royaRisk: 45, brocaRisk: 50)
//        ]),
//        .init(title: "Junio 2025", message: "Este mes hubo un aumento drástico en el riesgo del desarrollo de plagas y enfermedades debido al alto volumen de lluvia. El riesgo de roya subió a 90% y el riesgo de broca a 70%.", data: [
//            .init(year: 2025, month: "Jan", temperature: 16.338, rain: 33.8, royaRisk: 10, brocaRisk: 15),
//            .init(year: 2025, month: "Feb", temperature: 18.107, rain: 57.4, royaRisk: 20, brocaRisk: 30),
//            .init(year: 2025, month: "Mar", temperature: 19.072, rain: 25.4, royaRisk: 15, brocaRisk: 20),
//            .init(year: 2025, month: "Apr", temperature: 21.133, rain: 50, royaRisk: 35, brocaRisk: 40),
//            .init(year: 2025, month: "May", temperature: 23.538, rain: 78.8, royaRisk: 50, brocaRisk: 60),
//            .init(year: 2025, month: "Jun", temperature: 22.883, rain: 179.8, royaRisk: 90, brocaRisk: 70)
//        ])
//    ]
}
