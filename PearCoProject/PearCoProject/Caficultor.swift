//
//  Caficultor.swift
//  DataPersistenceDB
//
//  Created by Héctor Pablo González on 19/10/25.
//

import Foundation
import SwiftData
import UIKit


struct CaficultorResponse: Decodable {
    let results:[Caficultor]
    
}


struct Caficultor: Codable, Identifiable {
    let id: UUID
    let name: String
    let lastname: String
    let birthDate: Date
    let gender: String
    let telephone: String
    let email: String
    let address: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case lastname
        case birthDate
        case gender
        case telephone
        case email
        case address
    }
}


@Model
class CaficultorModel {
    var id = UUID()
    var name: String
    var lastname: String
    var birthDate: Date
    var gender: String
    var telephone: String
    var email: String
    var address: String
    
        
    init(id: UUID = UUID(), name: String, lastname: String, birthDate: Date, gender: String, telephone: String, email: String, address: String) {
        self.id = id
        self.name = name
        self.lastname = lastname
        self.birthDate = birthDate
        self.gender = gender
        self.telephone = telephone
        self.email = email
        self.address = address
    }
    
    // Check if email is valid with regex
    static func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
    
    // Check if caficultor is valid
    static func isValid(caficultor : CaficultorModel) -> Bool {
        let digits = CharacterSet.decimalDigits
        
        if(!caficultor.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && // name
           !caficultor.lastname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && // lastname
           !caficultor.gender.isEmpty && // gender
           (caficultor.telephone.count == 10 &&
             CharacterSet(charactersIn: caficultor.telephone).isSubset(of: digits)) && // telephone
           isValidEmail(caficultor.email) && // email
           !caficultor.address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && // address
           (caficultor.gender == "M" || caficultor.gender == "F" || caficultor.gender == "X")
           ) {
            
            return true
        }
        else {
            return false
        }
        
    }
}

extension CaficultorModel {
    
    
    
    @ModelActor
    actor BackgroundActor {
        
        func importCaficultores() async throws {
            guard let url = URL(string: "https://pearcoflaskapi.onrender.com/caficultores") else {
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let caficultores = try decoder.decode(CaficultorResponse.self, from: data)
                
                //print(caficultores)
                
                for caficultor in caficultores.results {
                    
                    let caficultorModel = CaficultorModel(id: caficultor.id, name: caficultor.name, lastname: caficultor.lastname, birthDate: caficultor.birthDate, gender: caficultor.gender, telephone: caficultor.telephone, email: caficultor.email, address: caficultor.address)
                    
                    let descriptor = FetchDescriptor<CaficultorModel>(
                        predicate: #Predicate { $0.id == caficultor.id }
                    )
                    let existing = try modelContext.fetch(descriptor)
                    if existing.isEmpty {
                        modelContext.insert(caficultorModel)
                    }
                }
                
                try modelContext.save()
                
                
                
            } catch  {
                throw error
            }

            
        }
        
    }

}
