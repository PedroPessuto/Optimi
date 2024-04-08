//
//  TaskView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 28/03/24.
//

import SwiftUI

struct TaskView: View {
	
	@Environment(GeneralController.self) var controller
	
	var task: TaskModel
	
	var body: some View {
		NavigationStack {
			
			topScreenView
			
			VStack(alignment: .leading) {
				HStack {
					Text("Informações")
						.font(.title)
					Spacer()
				}
				
				HStack(spacing: 5) {
					Image(systemName: "link")
						.foregroundStyle(.blue)
					Link("Protótipo", destination: URL(string: task.prototypeLink ?? "Task Link")!)
						.padding(.trailing, 50)
					
					Image(systemName: "link")
						.foregroundStyle(.blue)
					Link("Tarefa", destination: URL(string: task.taskLink ?? "Task Link")!)
				}
				.padding(.vertical, 10)
				
				//				 HStack {
				//					 Text("Equipe")
				//						 .font(.title)
				//					 Spacer()
				//				 }
				
				HStack {
					VStack {
						
					}
					VStack {
						
					}
				}
				Spacer()
			}
			.padding(.leading, 35)
			.padding(.top, 14)
		}
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button {
					
					controller.currentScreen = "Project"
					
					
				} label: {
					Image(systemName: "folder")
				}
				.disabled(true)
			}
			ToolbarItem(placement: .confirmationAction) {
				NavigationLink {
					DeliveryView(task: task)
				} label: {
					Image(systemName: "bubble.left.and.text.bubble.right")
				}
			}
		}
	}
}

#Preview {
	TaskView(task: TaskModel(id: 1, createdAt: Date.now, description: "Essa task precisa ser feita para ontem!", prototypeLink: "link do protótipo", taskLink: "link da task", status: "Status", taskName: "Task 1", designers: ["André Miguel", "Dani Brazolin Flauto"]))
}

extension TaskView {
	private var topScreenView: some View {
		VStack(alignment: .leading) {
			Spacer()
			HStack {
				Text(task.taskName ?? "Task Name")
					.font(.largeTitle)
					.fontWeight(.semibold)
				
				Text(task.status ?? "Task Status")
					.padding(.horizontal)
					.padding(.vertical, 5)
					.background()
					.clipShape(RoundedRectangle(cornerRadius: 360))
				
				Spacer()
			}
			
			Text(task.description ?? "Task Description")
				.padding(.bottom, 9)
			
			Button {
				Task{
					try await controller.updateTaskStatus(status: "Em Andamento", from: task.id ?? 0)
					try await controller.getInfo()
				}
			} label: {
				Text("Pegar Tarefa")
			}
			.keyboardShortcut(.defaultAction)
		}
		.padding(.leading, 35)
		.padding(.bottom, 14)
		.background()
	}
	
	private var bottomScreenView: some View {
		VStack {
			
		}
	}
}
