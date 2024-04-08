//
//  CreateProjectView.swift
//  Optimi
//
//  Created by Marina Martin on 28/03/24.
//

import SwiftUI

struct CreateProjectView: View {
	
	@Environment(\.dismiss) private var dismiss
	@State public var projectName: String = ""
	
	@Environment(GeneralController.self) var controller
	
	var body: some View {
		NavigationStack{
			VStack{
				HStack{
					Text("Crie o seu projeto")
						.font(.title)
					Spacer()
				}
				
				HStack{
					Text("Nome do Projeto")
						.font(.headline)
					Spacer()
				}
				HStack{
					TextField("Projeto", text: $projectName)
				}
				
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
						dismiss()
						controller.currentScreen = "Project"
						Task {
							let project = ProjectModel(projectName: "\(projectName)")
							
							await controller.supabaseController.insertOne(tableName: "Project", object: project)
							
							controller.projectKey = project.projectKey!
							controller.viewController.project = project
						}
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
