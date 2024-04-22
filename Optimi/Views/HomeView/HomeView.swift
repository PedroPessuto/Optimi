//
//  HomeView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import SwiftUI
import Aptabase

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
                            .padding()
                        }
                        
                        Spacer()
                        // Criar Projeto
                        Button(action: {
                            createProjectViewIsPresented.toggle()
                            Aptabase.shared.trackEvent("Abriu o formulário de criação de um projeto")
                        }) {
                            Text("Criar Projeto")
                            Image(systemName: "plus")
                        }
                        .font(.title3)
                        .padding()
#if os(macOS)
                        .foregroundColor(.accent)
                        .buttonStyle(.plain)
#endif
                    }
                }
                // ========== BODY ==========
                VStack (spacing: 20) {
                    HStack {
                        Text("Token do Projeto")
#if os(macOS)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
#endif
#if os(iOS)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
#endif
                        Spacer()
                    }
                    oInput(text: "Insira o token aqui", binding: $projectKey)
                        .onSubmit {
                            getProject()
                            Aptabase.shared.trackEvent("Tentou acessar um projeto")
                        }
                        .disabled(isLoading)
                    oButton(text: "Entrar no Projeto") {
                        getProject()
                    }
                    .isDisabled(isLoading)
                    .variant(.fill)
                    .keyboardShortcut(.defaultAction)
                }
                .frame(width: 300)
                .frame(maxHeight: .infinity)
            }
            .background(){
                Image("Inicio")
#if os(macOS)
                    .resizable()
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
                    .interactiveDismissDisabled(true)
            }
            .onChange(of: controller.screen) { oldValue, newValue in
                if newValue == .ProjectNotFoundView {
                    projectNotFoundSheetIsPresented = true
                    projectKey = ""
                    controller.screen = .HomeView
                }
            }
        }
    }
}
