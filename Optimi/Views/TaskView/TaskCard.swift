//
//  TaskCardView.swift
//  Optimi
//
//  Created by Marina Martin on 10/04/24.
//

import SwiftUI

struct TaskCard: View {
	@Environment(\.colorScheme) var colorScheme
    @Environment(GeneralController.self) var controller
	 var task: TaskModel
    @Environment(\.dismiss) private var dismiss

	@State var focused: Bool = false
	
	 var body: some View {
		  VStack {
				HStack {
					 Text(task.taskName)
						  .font(.title3)
						  .multilineTextAlignment(.leading)
					 
					 Spacer()
					 
					StatusPill(status: task.taskStatus!)
						.foregroundStyle(focused ? .red : .blue)
				}
				.padding(.bottom)
				
				HStack {
					 Image(systemName: "person.fill")
					 Text(task.taskDesigners ?? "")
						  .foregroundStyle(.secondary)
					 
					 Spacer()
					 
					Menu {
						Button(role: .destructive) {
							Task {
								await controller.deleteTask(taskModel: task)
							}
                            dismiss()
                        
						} label: {
							HStack {
								Image(systemName: "trash")
								Text("Deletar task")
							}
						}
						
					} label: {
						Image(systemName: "ellipsis.circle")
					}
                    .foregroundStyle(.accent)
					.buttonStyle(PlainButtonStyle())
					.padding(.vertical, 5)
					.padding(.horizontal, 3)
				}
		  }.frame(height: 77)
			 .onTapGesture {
				 withAnimation(.easeInOut(duration: 0.3)) {
					 self.focused.toggle()
				 }
			 }
	 }
}

//#Preview {
//	 TaskCard(task: TaskModel(id: 1, createdAt: "10/05/2024", description: "Essa task precisa ser feita para ontem!", prototypeLink: "link do protótipo", taskLink: "link da task", status: "Ready for Dev", taskName: "Task 1", designers: "André Miguel, Dani Brazolin Flauto"))
//}

extension TaskCard {
	 func statusColor(for string: String) -> Color {
		  switch string {
		  case "Ready for Dev":
				return .backgroundOrange
		  case "Aprovada":
				return .backgroundGreen
		  case "Revisão Pendente":
				return .backgroundYellow
		  case "Reprovada":
				return .backgroundRed
		  case "Em Andamento":
				return .backgroundBlue
		  default:
				return .black
		  }
	 }
}
