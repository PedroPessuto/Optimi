//
//  ContentView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(GeneralController.self) private var generalController
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: {
                Task {
                    await generalController.createProject("Teste")
                }
            }) {
                Text("Criar Projeto")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
