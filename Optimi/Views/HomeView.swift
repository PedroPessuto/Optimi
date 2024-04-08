//
//  HomeView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 28/03/24.
//

import SwiftUI

struct HomeView: View {
	
	@Environment(GeneralController.self) private var controller
	@State var OnboardingViewIsPresented: Bool = false
	@State var CreateProjectViewIsPresented: Bool = false
	@State var projectNotFoundSheetIsPresented: Bool = false
	@State var token: String = ""
	@State var isLoading: Bool = false
	
	func getProject() async -> Void {
		
		if isLoading {
			return
		}
		
		do {
			isLoading = true
			let response = try await controller.supabaseController.getProject(projectToken: token)
			
			if response == nil {
				projectNotFoundSheetIsPresented = true
				token = ""
			}
			else {
				projectNotFoundSheetIsPresented = false
				controller.projectKey = token
				controller.currentScreen = "Project"
				
			}
			isLoading = false
		}
		catch {
			print("Erro ao encontrar projeto: \(error)")
			isLoading = false
		}
		
	}
	
	var body: some View {
		
		NavigationStack {
			
			VStack {
				// ==========================
				//           HEADER
				// ==========================
				
				// ======== IOS ========
#if os(iOS)
				HStack {
					Button (action: {OnboardingViewIsPresented.toggle()}) {
						HStack {
							Image(systemName: "person.fill")
								.resizable()
								.frame(width: 30, height: 30)
								.foregroundStyle(Color("PrimaryColor"))
							
							VStack(alignment: .leading) {
								
								Text("\(controller.cargo)")
									.font(.system(size: 15))
									.fontWeight(.thin)
								
								Text("\(controller.nome)")
									.font(.system(size: 20))
									.fontWeight(.regular)
								
							}
							
						}
						
					}
					
					Spacer()
					
					HStack {
						Button(action: {CreateProjectViewIsPresented.toggle()}) {
							Text("Criar Projeto +")
						}
					}
				}
#endif
				
				// ======== MacOS ========
#if os(macOS)
				VStack{
					HStack{
						Button(action: {
							OnboardingViewIsPresented.toggle()
						}, label: {
							HStack{
								VStack{
									Image(systemName: "person.fill")
								}
								VStack(alignment: .leading) {
									HStack{
										Text("\(controller.cargo)")
									}
									HStack{
										Text("\(controller.nome)")
										Image(systemName: "pencil")
									}
								}
							}
						})
						.foregroundColor(.gray)
						.font(.title3)
						.buttonStyle(.plain)
						
						
						Spacer()
						
						Button(action: {
							CreateProjectViewIsPresented.toggle()
						}, label: {
							Text("Criar Projeto")
							Image(systemName: "plus")
						}).font(.title3)
							.foregroundColor(.gray)
							.buttonStyle(.plain)
						
					}
					
				}
				
#endif
				
				// ==========================
				//           BODY
				// ==========================
				
				VStack (spacing: 20) {
					
#if os(iOS)
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
							if (newValue.count == 51) {
								Task {
									await getProject()
								}
							}
						}
						.onSubmit {
							Task {
								await getProject()
							}
						}
					
					
					
					Button(action: {
						Task {
							await getProject()
						}
					}) {
						HStack {
							Text("Entrar no projeto")
						}
					}
					.clipShape(Capsule())
					.buttonStyle(.borderedProminent)
					.keyboardShortcut(.defaultAction)
					
#endif
					
#if os(macOS)
					
					HStack{
						Text("Token do Projeto")
							.font(.headline)
						Spacer()
					}
					
					TextField("Insira o token aqui", text: $token)
						.onChange(of: token) { oldValue, newValue in
							if (newValue.count == 51) {
								Task {
									await getProject()
								}
							}
						}
						.onSubmit {
							Task {
								await getProject()
							}
						}
					
					
					Button(action: {
						Task {
							await getProject()
						}
					}) {
						HStack {
							Text("Entrar no projeto")
						}
					}
					.keyboardShortcut(.defaultAction)
					
					
#endif
				}
				.frame(width: 300)
				.frame(maxHeight: .infinity)
				
				
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.padding(22.5)
			.sheet(isPresented: $projectNotFoundSheetIsPresented) {
				ProjectNotFoundView()
			}
			.sheet(isPresented: $CreateProjectViewIsPresented) {
				CreateProjectView()
			}
			.sheet(isPresented: $OnboardingViewIsPresented) {
				OnboardingView()
			}
			
			
		}
		
	}
}




