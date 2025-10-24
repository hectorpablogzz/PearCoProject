//
//  CaficultorTests.swift
//  CaficultorTests
//
//  Created by Héctor Pablo González on 23/10/25.
//

import Testing
@testable import PearCoProject
internal import Foundation

import Testing
@testable import PearCoProject
internal import Foundation

struct CaficultorTests {

    @Test("All fields must be valid")
    func testValidation() {
        // ✅ All fields
        #expect(CaficultorModel.isValid(caficultor: CaficultorModel(name: "Juan", lastname: "Perez", birthDate: .now, gender: "M", telephone: "1234567890", email: "aaa@aaa.aaa", address: "123 Street")))
        
        // ✅ All fields
        #expect(CaficultorModel.isValid(caficultor: CaficultorModel(name: "Ana", lastname: "Gomez", birthDate: .now, gender: "F", telephone: "1234567890", email: "abc@def.com", address: "456 Street")))
        
        // ❌ Blank fields
        #expect(!CaficultorModel.isValid(caficultor: CaficultorModel(name: "", lastname: "", birthDate: .now, gender: "M", telephone: "", email: "", address: "")))
        
        // ❌ Incorrect formatting
        #expect(!CaficultorModel.isValid(caficultor: CaficultorModel(name: "Pedro", lastname: "Gutierrez", birthDate: .now, gender: "M", telephone: "123", email: "123.com", address: "789 Street")))
        
    }
    
    @Test("Name length boundaries are still valid if it's not empty")
    func testNameBoundaries() {
        // ✅ Min
        #expect(CaficultorModel.isValid(caficultor: CaficultorModel(name: "A", lastname: "A", birthDate: .now, gender: "M", telephone: "1234567890", email: "aaa@aaa.aaa", address: "A")))
        
        // ✅ Max
        #expect(CaficultorModel.isValid(caficultor: CaficultorModel(name: String(repeating: "X", count: 255), lastname: String(repeating: "X", count: 255), birthDate: .now, gender: "M", telephone: "1234567890", email: "aaa@aaa.aaa", address: String(repeating: "X", count: 255))))
    }
    
    @Test("Email addresses formatting")
    func testEmails() {
        // ✅ Correct syntax
        #expect(CaficultorModel.isValidEmail("abc@def.com"))
        
        // ❌ No name
        #expect(!CaficultorModel.isValidEmail("@def.com"))
        
        // ❌ No @
        #expect(!CaficultorModel.isValidEmail("abcdef.com"))
        
        // ❌ No .
        #expect(!CaficultorModel.isValidEmail("abc@defcom"))
        
        // ❌ No @ or .
        #expect(!CaficultorModel.isValidEmail("abcdef"))
        
        // ❌ No domain name
        #expect(!CaficultorModel.isValidEmail("abcdef@.com"))
        
        // ❌ No text
        #expect(!CaficultorModel.isValidEmail(""))
        
        // ❌ only @ and .
        #expect(!CaficultorModel.isValidEmail("@."))
        
        // ❌ wrong order
        #expect(!CaficultorModel.isValidEmail("abc.com@def"))
    }

}

