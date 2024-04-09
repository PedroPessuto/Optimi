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
            
            Button(action: {
                Task {
                    await generalController.getProject("159824D2-5656-4907-AB2F-3974A5B1688B")
                    print(generalController.project?.projectName)
                }
            }) {
                Text("Printar projeto")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
