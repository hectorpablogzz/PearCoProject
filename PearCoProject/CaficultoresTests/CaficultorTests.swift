//
//  CaficultoresTests.swift
//  CaficultoresTests
//
//  Created by Héctor Pablo González on 05/10/25.
//

import Testing
@testable import PearCoProject
internal import Foundation

struct CaficultorTests {

    @Test("All fields must be valid")
    func testValidation() {
        // ✅ All fields
        #expect(Caficultor.isValid(caficultor: Caficultor(name: "Juan", lastname: "Perez", birthDate: .now, gender: "M", telephone: "1234567890", email: "aaa@aaa.aaa", address: "123 Street")))
        
        // ✅ All fields
        #expect(Caficultor.isValid(caficultor: Caficultor(name: "Ana", lastname: "Gomez", birthDate: .now, gender: "F", telephone: "1234567890", email: "abc@def.com", address: "456 Street")))
        
        // ❌ Blank fields
        #expect(!Caficultor.isValid(caficultor: Caficultor(name: "", lastname: "", birthDate: .now, gender: "M", telephone: "", email: "", address: "")))
        
        // ❌ Incorrect formatting
        #expect(!Caficultor.isValid(caficultor: Caficultor(name: "Pedro", lastname: "Gutierrez", birthDate: .now, gender: "M", telephone: "123", email: "123.com", address: "789 Street")))
        
    }
    
    @Test("Name length boundaries are still valid if it's not empty")
    func testNameBoundaries() {
        // ✅ Min
        #expect(Caficultor.isValid(caficultor: Caficultor(name: "A", lastname: "A", birthDate: .now, gender: "M", telephone: "1234567890", email: "aaa@aaa.aaa", address: "A")))
        
        // ✅ Max
        #expect(Caficultor.isValid(caficultor: Caficultor(name: String(repeating: "X", count: 255), lastname: String(repeating: "X", count: 255), birthDate: .now, gender: "M", telephone: "1234567890", email: "aaa@aaa.aaa", address: String(repeating: "X", count: 255))))
    }
    
    @Test("Email addresses formatting")
    func testEmails() {
        // ✅ Correct syntax
        #expect(Caficultor.isValidEmail("abc@def.com"))
        
        // ❌ No name
        #expect(!Caficultor.isValidEmail("@def.com"))
        
        // ❌ No @
        #expect(!Caficultor.isValidEmail("abcdef.com"))
        
        // ❌ No .
        #expect(!Caficultor.isValidEmail("abc@defcom"))
        
        // ❌ No @ or .
        #expect(!Caficultor.isValidEmail("abcdef"))
        
        // ❌ No domain name
        #expect(!Caficultor.isValidEmail("abcdef@.com"))
        
        // ❌ No text
        #expect(!Caficultor.isValidEmail(""))
        
        // ❌ only @ and .
        #expect(!Caficultor.isValidEmail("@."))
        
        // ❌ wrong order
        #expect(!Caficultor.isValidEmail("abc.com@def"))
    }

}

