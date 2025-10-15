//
//  MessageView.swift
//  PearCoProject
//
//  Created by José Francisco González on 15/10/25.
//

import SwiftUI

struct MessageView: View {
    let error: Error?
    let message: String?
    
    init(error: Error? = nil, message: String? = nil) {
        self.error = error
        self.message = message
    }
    
    var body: some View {
        VStack {
            Spacer()
            if let error {
                Text("\(error.localizedDescription)")
                    .foregroundStyle(.red)
                    .padding(5)
            } else if let message {
                Text("\(message)")
                    .foregroundStyle(.black)
                    .font(.title3)
                    .padding(15)
            }
            Spacer()
        }
        }
    }

