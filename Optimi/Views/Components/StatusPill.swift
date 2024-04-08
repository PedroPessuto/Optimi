//
//  StatusPill.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 05/04/24.
//

import SwiftUI

struct StatusPill: View {
	
	var task: TaskModel
	//	var status: statusColor {
	//		let status = task.status
	//
	//	}
	
	var body: some View {
		HStack(spacing: 4) {
			Text(task.status ?? "")
			Image(systemName: statusImage(for: task.status!))
		}
		.padding(.horizontal, 9)
		.padding(.vertical, 3)
		.background(statusColor(for: task.status!))
		.clipShape(RoundedRectangle(cornerRadius: 360))
	}
}

#Preview {
	StatusPill(task: TaskModel(id: 1, createdAt: Date.now, description: "Essa task precisa ser feita para ontem!", prototypeLink: "link do protótipo", taskLink: "link da task", status: "Status", taskName: "Task 1", designers: ["André Miguel", "Dani Brazolin Flauto"]))
}


extension StatusPill {
	func statusColor(for string: String) -> Color {
		switch string {
		case "Ready for dev":
			return .statusPurple
		case "Ready for Designer":
			return .statusOrange
		case "Aprovada":
			return .statusGreen
		case "Revisão Pendente":
			return .statusYellow
		case "Reprovada":
			return .statusRed
		case "Em Andamento":
			return .statusBlue
		default:
			return .black
		}
	}
	
	func statusImage(for string: String) -> String {
		switch string {
		case "Ready for dev":
			return "exclamationmark"
		case "Ready for Designer":
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
}


//enum statusColor {
//	case readyForDev
//	case aprovada
//	case revisaoPendente
//	case emAndamento
//	case readyForDesigner
//	case reprovada
//
//	var color: Color {
//		switch self {
//		case .readyForDev:
//			return .purple
//		case .aprovada:
//			return .green
//		case .revisaoPendente:
//			return .yellow
//		case .emAndamento:
//			return .blue
//		case .readyForDesigner:
//			return .orange
//		case .reprovada:
//			return .red
//		}
//	}
//}
