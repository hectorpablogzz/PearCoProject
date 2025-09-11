//
//  ContentView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct ContentView: View {
    let verdeOscuro = Color(red: 32/255, green: 75/255, blue: 54/255)
    var body: some View {
        
        CustomTabView()
            .padding(.top, 10)
            .edgesIgnoringSafeArea(.bottom)
        }
}




#Preview {
    ContentView()
}
