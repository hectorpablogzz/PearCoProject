//
//  Farmer.swift
//  PearCoProject
//
//  Created by Héctor Pablo González on 05/10/25.
//

import Foundation

struct Caficultor: Identifiable, Decodable, Encodable {
    var id = UUID()
    var name: String
    var lastname: String
    var birthDate: Date
    var gender: String
    var telephone: String
    var email: String
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case name, lastname, birthDate, gender, telephone, email, address
    }
    
    
    // Check if email is valid with regex
    static func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
    
    // Check if caficultor is valid
    static func isValid(caficultor : Caficultor) -> Bool {
        let digits = CharacterSet.decimalDigits
        
        if(!caficultor.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && // name
           !caficultor.lastname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && // lastname
           !caficultor.gender.isEmpty && // gender
           ((caficultor.telephone.count == 10 &&
             CharacterSet(charactersIn: caficultor.telephone).isSubset(of: digits)) ||
            caficultor.telephone.isEmpty) && // telephone (can be empty)
           (isValidEmail(caficultor.email) || caficultor.email.isEmpty) && // email (can be empty)
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
