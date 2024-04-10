//
//  CreateProjectView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import SwiftUI

struct CreateProjectView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(GeneralController.self) var controller
    
    @State public var projectName: String = ""
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("Crie o seu projeto")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
                
                Text("Nome do Projeto")
                    .font(.headline)
                
                TextField("Projeto", text: $projectName)
                    .padding(.bottom)
                
                HStack{
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        ZStack{
                            Text("Fechar")
                        }
                    })
                    
                    Button {
                        Task {
                            await controller.createProject(projectName)
                        }
                        
                        dismiss()
                    } label: {
                        ZStack{
                            Text("Criar Projeto")
                        }
                    }.disabled(projectName == "" ? true : false)
                    
                }
            }
            .padding()
        }.frame(minWidth: 289, maxWidth: 350, minHeight: 138, maxHeight: 250)
    }
}

#Preview {
    CreateProjectView(projectName: "")
}
