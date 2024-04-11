//
//  Status Pill.swift
//  Optimi
//
//  Created by Marina Martin & Paulo Sonzzini on 10/04/24.
//

import SwiftUI

struct StatusPill: View {
	 
	 var task: TaskModel
	 
	 var body: some View {
			HStack(spacing: 4) {
				 Text(task.taskStatus!)
					  .foregroundStyle(statusTextColor(for: task.taskStatus!))
				 Image(systemName: statusImage(for: task.taskStatus!))
					  .foregroundStyle(statusTextColor(for: task.taskStatus!))
			}
			.padding(.horizontal, 9)
			.padding(.vertical, 3)
			.background(statusColor(for: task.taskStatus!))
			.clipShape(RoundedRectangle(cornerRadius: 360))
	 }
}

//#Preview {
//	 StatusPill(task: TaskModel(id: 1, createdAt: "10/05/2024", description: "Essa task precisa ser feita para ontem!", prototypeLink: "link do protótipo", taskLink: "link da task", status: "Status", taskName: "Task 1", designers: "André Miguel, Dani Brazolin Flauto"))
//}

extension StatusPill {
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
	 
	 func statusImage(for string: String) -> String {
		  switch string {
		  case "Ready for Dev":
				return "exclamationmark"
		  case "Aprovada":
				return "checkmark"
		  case "Revisão Pendente":
				return "pencil"
		  case "Reprovada":
				return "xmark"
		  case "Em Andamento":
				return "circle.hexagonpath"
		  default:
				return ""
		  }
	 }
	 
	 func statusTextColor(for string: String) -> Color {
		  switch string {
		  case "Ready for Dev":
				return .textOrange
		  case "Aprovada":
				return .textGreen
		  case "Revisão Pendente":
				return .textYellow
		  case "Reprovada":
				return .textRed
		  case "Em Andamento":
				return .textBlue
		  default:
				return .black
		  }
	 }
}
