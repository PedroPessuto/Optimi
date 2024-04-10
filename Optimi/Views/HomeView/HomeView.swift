//
//  HomeView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(GeneralController.self) private var controller
    @Environment(\.dismiss) private var dismiss
    
    @State var onboardingViewIsPresented: Bool = true
    @State var createProjectViewIsPresented: Bool = false
    @State var projectNotFoundSheetIsPresented: Bool = false
    
    @State var projectKey: String = ""
    @State var isLoading: Bool = false
    
    func getProject() -> Void {
        if projectKey == "" {
            return
        }
        Task {
            isLoading = true
            await controller.getProject(projectKey)
            isLoading = false
        }
    }
    
    
    var body: some View {
        
        NavigationStack {

            VStack {
                VStack {
                    
                    // ========== HEADER ==========
                    HStack {
                        
                        // Dados da conta
                        if(controller.account != nil) {
                            
                            AccountHomeDisplay {
                                onboardingViewIsPresented.toggle()
                            }
                            
                        }
                        
                        Spacer()
                        
                        // Criar Projeto
                        Button(action: {
                            createProjectViewIsPresented.toggle()
                        }) {
                            Text("Criar Projeto")
                            Image(systemName: "plus")
                        }
                        .font(.title3)
                        .foregroundColor(.gray)
                        .buttonStyle(.plain)
                        
                    }
                    
                }
                
                // ========== BODY ==========
                
                VStack (spacing: 20) {
                    HStack{
                        Text("Token do Projeto")
                            .font(.headline)
                        
//                        Text("Token Do Projeto")
//                            .font(.system(size: 20))
//                            .fontWeight(.semibold)
//                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    oInput(text: "Insira o token aqui", binding: $projectKey)
                        .onChange(of: projectKey) { _, newValue in
                            if (newValue.count == 36) {
                                getProject()
                            }
                        }
                        .onSubmit {
                            getProject()
                        }
                        .disabled(isLoading)
                    
                    HStack {
                        oButton(text: "Entrar no Projeto") {
                            getProject()
                        }
                        .isDisabled(isLoading)
                        .variant(.fill)
                        .keyboardShortcut(.defaultAction)
                    }

                }
                .frame(width: 300)
                .frame(maxHeight: .infinity)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(22.5)

        }
        .sheet(isPresented: $projectNotFoundSheetIsPresented) {
            ProjectNotFoundView()
        }
        .sheet(isPresented: $createProjectViewIsPresented) {
            CreateProjectView()
        }
        .sheet(isPresented: $onboardingViewIsPresented) {
            OnboardingView()
        }
        // Função para ativar ou desativar sheet de não achar projeto
        .onChange(of: controller.screen) { oldValue, newValue in
            if newValue == .ProjectNotFoundView {
                projectNotFoundSheetIsPresented = true
                projectKey = ""
                controller.screen = .HomeView
            }
        }
        
        
    }
}
