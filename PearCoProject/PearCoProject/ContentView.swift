//
//  ContentView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        
        CustomTabView()
            .padding(.top, 10)
            .edgesIgnoringSafeArea(.bottom)
            .modelContainer(for: CaficultorModel.self)
        }
}




#Preview {
    ContentView()
}
