//
//  TaskCardView.swift
//  Optimi
//
//  Created by Marina Martin on 10/04/24.
//

import SwiftUI

struct TaskCard: View {
	 
	 var task: TaskModel
	 
	 var body: some View {
		  VStack {
				HStack {
					 Text(task.taskName)
						  .font(.title3)
						  .multilineTextAlignment(.leading)
					 
					 Spacer()
					 
					 StatusPill(task: task)
				}
				.padding(.bottom)
				
				HStack {
					 Image(systemName: "person.fill")
					 Text(task.designers)
						  .foregroundStyle(.secondary)
					 
					 Spacer()
					 
					 Button {
						  //vai abrir um Menu com as duas opções
						  //Aqui vai ter a opção de Delete e Update
					 } label: {
						  Image(systemName: "ellipsis")
					 }
					 .buttonStyle(PlainButtonStyle())
					 .padding(.vertical, 5)
				}
		  }.frame(height: 77)
	 }
}

#Preview {
	 TaskCard(task: TaskModel(id: 1, createdAt: "10/05/2024", description: "Essa task precisa ser feita para ontem!", prototypeLink: "link do protótipo", taskLink: "link da task", status: "Ready for Dev", taskName: "Task 1", designers: "André Miguel, Dani Brazolin Flauto"))
}

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
