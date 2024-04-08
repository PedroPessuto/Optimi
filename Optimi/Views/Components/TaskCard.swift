//
//  TaskCard.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 02/04/24.
//

import SwiftUI

struct TaskCard: View {
	
	var task: TaskModel
	
	var body: some View {
		VStack {
			HStack {
				taskName
				
				Spacer()
				
				taskStatus
				
			}
			HStack {
				//taskDesigners
				
				Spacer()
				
				taskEllipsisButton
			}
		}
		//.padding()
	}
}



#Preview {
	TaskCard(task: TaskModel(id: 1, createdAt: Date.now, description: "Essa task precisa ser feita para ontem!", prototypeLink: "link do protótipo", taskLink: "link da task", status: "Status", taskName: "Task 1", designers: ["André Miguel", "Dani Brazolin Flauto"]))
}


extension TaskCard {
	private var taskName: some View {
		Text(task.taskName ?? "")
			.font(.title3)
	}
	
	private var taskStatus: some View {
		//		Text(task.status ?? "")
		//			.padding(.horizontal)
		//			.padding(.vertical, 5)
		//			.background()
		//			.clipShape(RoundedRectangle(cornerRadius: 360))
		StatusPill(task: task)
	}
	
	//	private var taskDesigners: some View {
	//		HStack {
	//			Image(systemName: "person.fill")
	//				.font(.title)
	//
	//			Text(task.designers?.first ?? "")
	//		}
	//	}
	
	private var taskEllipsisButton: some View {
		Button {
			
		} label: {
			Image(systemName: "ellipsis")
		}
		.buttonStyle(PlainButtonStyle())
		.padding(.vertical, 5)
	}
}
