//
//  CreateTaskView.swift
//  rendy
//
//  Created by Marina Martin on 02/04/24.
//

import SwiftUI

struct CreateTaskView: View {
	
	@Environment(\.dismiss) private var dismiss
	@Environment(GeneralController.self) var controller
	
	@State public var taskName: String = ""
	@State public var taskDescription: String = ""
	@State public var prototypeLink: String = ""
	@State public var taskLink: String = ""
	
	var body: some View {
		NavigationStack{
			VStack(alignment: .leading){
				Text("Criar Task")
					.font(.title)
				Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. ")
					.font(.footnote)
					.foregroundColor(.gray)
				Text("Nome da Task")
					.font(.headline)
				TextField("Task", text: $taskName)
				Text("Descrição da Task")
					.font(.headline)
				TextField("Descrição", text: $taskDescription)
				HStack{
					VStack{
						Text("Link do Protótipo")
							.font(.headline)
						TextField("Link", text: $prototypeLink)
					}
					.padding(.trailing)
					Spacer()
					VStack{
						Text("Link da Tarefa")
							.font(.headline)
						TextField("Link", text: $taskLink)
					}
				}
				
				HStack{
					Spacer()
					
					Button(action: {
						dismiss()
					}, label: {
						ZStack{
							Text("Cancelar")
						}
					})
					
					Button(action: {
						
						var task: TaskModel? = TaskModel(description: taskDescription, prototypeLink: prototypeLink, taskLink: taskLink, status: "Ready for dev", taskName: taskName)
						
						Task {
							task = await controller.supabaseController.insertOneAndReturn(tableName: "Task", object: task)!
							
							var task_project: ProjectTaskModel? = nil
							
							if let y = task {
								task_project = ProjectTaskModel(idProject: controller.viewController.project?.projectId, idTask: y.id)
								
								if let x = task_project {
									task_project = await controller.supabaseController.insertOneAndReturn(tableName: "Project-Task", object: x)
								}
							}
						}
						
						//adicionar o projeto na tabela
						dismiss()
					}, label: {
						ZStack{
							Text("Criar Task")
						}
					})
				}
			}
			.padding()
		}.frame(minWidth: 511, minHeight: 433)
			.onDisappear {
				print("Create Task View desapareceu!")
				Task {
					do {
						try await controller.getInfo()
					} catch {
						print("Error updating with new task: \(error)")
					}
				}
			}
	}
}

#Preview {
	CreateTaskView()
}
