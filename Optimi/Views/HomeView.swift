//
//  HomeView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(GeneralController.self) private var controller
    
    @State var onboardingViewIsPresented: Bool = true
    @State var createProjectViewIsPresented: Bool = false
    @State var projectNotFoundSheetIsPresented: Bool = false
    
    @State var token: String = ""
    @State var isLoading: Bool = false
    
    var body: some View {
        
        
        NavigationStack {
            
#if os(macOS)
            VStack {
                VStack {
                    
                    // ========== HEADER ==========
                    HStack {
                        
                        // Dados da conta
                        if(controller.account != nil) {
                    
                            Button (action: {
                                onboardingViewIsPresented.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    VStack(alignment: .leading) {
                                        Text(controller.account?.accountRole.rawValue ?? "Nenhum Cargo")
                                        HStack {
                                            Text(controller.account?.accountName ?? "Seu Nome")
                                            Image(systemName: "pencil")
                                        }
                                    }
                                }
                            }
                            .foregroundColor(.gray)
                            .font(.title3)
                            .buttonStyle(.plain)
                            
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
                        Spacer()
                    }
                    
                    TextField("Insira o token aqui", text: $token)
                        .onChange(of: token) { _, newValue in
                            if (newValue.count == 36) {
                                Task {
                                    await controller.getProject(newValue)
                                }
                            }
                        }
                        .onSubmit {
                            Task {
                                await controller.getProject(token)
                            }
                        }
                    
                    Button(action: {
                        Task {
                            await controller.getProject(token)
                        }
                    }) {
                        HStack {
                            Text("Entrar no projeto")
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                }
                .frame(width: 300)
                .frame(maxHeight: .infinity)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(22.5)
#endif
            
#if os(iOS)
            
            VStack {
                VStack {
                    
                    // ========== HEADER ==========
                    HStack {
                        
                        // Dados da conta
                        if(controller.account != nil) {
                            
                            Button (action: {onboardingViewIsPresented.toggle()}) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(.blue)
                                    
                                    VStack(alignment: .leading) {
                                        Text(controller.account?.accountRole.rawValue ?? "Nenhum Cargo")
                                            .font(.system(size: 15))
                                            .fontWeight(.thin)
                                        Text(controller.account?.accountName ?? "Seu Nome")
                                            .font(.system(size: 20))
                                            .fontWeight(.regular)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Criar Projeto
                        HStack {
                            Button(action: {createProjectViewIsPresented.toggle()}) {
                                Text("Criar Projeto +")
                            }
                        }
                        
                    }
                    
                }
                
                // ========== BODY ==========
                
                VStack (spacing: 20) {
                    Text("Token Do Projeto")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)

                    TextField("Insira o token aqui", text: $token)
                        .foregroundColor(Color(UIColor(red: 60/256, green: 60/256, blue: 67/256, alpha: 0.3)))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 7)
                                .fill(Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)))
                        )
                        .onChange(of: token) { oldValue, newValue in
                            if (newValue.count == 36) {
                                Task {
                                    await controller.getProject(newValue)
                                }
                            }
                        }
                        .onSubmit {
                            Task {
                                Task {
                                    await controller.getProject(token)
                                }
                            }
                        }

                    Button(action: {
                        Task {
                            await controller.getProject(token)
                        }
                    }) {
                            Text("Entrar no projeto")
                    }
                    .clipShape(Capsule())
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
                }
                .frame(width: 300)
                .frame(maxHeight: .infinity)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(22.5)
            
#endif
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
                token = ""
            }
            else {
                projectNotFoundSheetIsPresented = false
            }
        }
        
        
    }
}
