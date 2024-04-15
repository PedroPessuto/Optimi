//
// CreateProjectView.swift
// Optimi
//
// Created by Pedro Pessuto on 09/04/24.
//
import SwiftUI
struct CreateProjectView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(GeneralController.self) var controller
	@State private var isLoading: Bool = false
	@State public var projectName: String = ""
	func createProject() async -> Void {
		if (projectName == "") {
			return
		}
		isLoading = true
		await controller.createProject(projectName)
		isLoading = false
	}
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
					.onSubmit {
						Task {
							await createProject()
						}
					}
					.disabled(isLoading)
#if os(iOS)
					.textFieldStyle(.roundedBorder)
#endif
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
							await createProject()
						}
						dismiss()
					} label: {
						ZStack{
							Text("Criar Projeto")
						}
					}
					.disabled(isLoading || projectName == "")
				}
			}
			.padding()
		}
#if os(macOS)
		.frame(minWidth: 289, maxWidth: 350, minHeight: 138, maxHeight: 250)
#endif
	}
}
#Preview {
	CreateProjectView(projectName: "")
}
