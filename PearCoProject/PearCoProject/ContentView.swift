//
//  ContentView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        CustomTabView()
            .accentColor(.green)
            .padding(.top, 10)
            .edgesIgnoringSafeArea(.bottom)
        }
}




#Preview {
    ContentView()
}
