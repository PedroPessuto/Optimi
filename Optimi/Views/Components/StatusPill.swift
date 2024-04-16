//
//  Status Pill.swift
//  Optimi
//
//  Created by Marina Martin on 10/04/24.
//

import SwiftUI

struct StatusPill: View {
	 
	 var status: String
	 
	 var body: some View {
			HStack(spacing: 4) {
				 Text(status)
					  .foregroundStyle(statusTextColor(for: status))
				 Image(systemName: statusImage(for: status))
					  .foregroundStyle(statusTextColor(for: status))
			}
			.padding(.horizontal, 9)
			.padding(.vertical, 3)
			.background(statusColor(for: status))
			.clipShape(RoundedRectangle(cornerRadius: 360))
	 }
}


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
