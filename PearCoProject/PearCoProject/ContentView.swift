//
//  ContentView.swift
//  PearCoProject
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel


    var body: some View {
       
        CustomTabView()
            .padding(.top, 10)
            .edgesIgnoringSafeArea(.bottom)
            
            .modelContainer(for: CaficultorModel.self)

        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}

