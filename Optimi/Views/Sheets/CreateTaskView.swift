//
// CreateTaskView.swift
// rendy
//
// Created by Marina Martin on 02/04/24.
//
import SwiftUI
import Aptabase


struct CreateTaskView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	@Environment(GeneralController.self) var controller
	
	@State public var taskName: String = ""
	@State public var taskDescription: String = ""
	@State public var prototypeLink: String = ""
	@State public var taskLink: String = ""
	@State public var taskDesigners: String = ""
	
	@State public var taskDeadline: Date = Date.now
	
	var body: some View {
		NavigationStack{
			VStack(alignment: .leading){
				
				Text("Criar Task")
					.font(.title)
					.bold()
				
//				Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. ")
//					.font(.footnote)
//					.foregroundColor(.gray)
//					.padding(.bottom, 22)
				
				Text("Nome da Task")
					.font(.headline)
					.fontWeight(.semibold)
				
				TextField("Nome da Task", text: $taskName)
					.textFieldStyle(.roundedBorder)
					.padding(.bottom, 14)
				
				Text("Descrição da Task")
					.font(.headline)
					.fontWeight(.semibold)
					.padding(.bottom, 5)
				
				VStack {
//					TextEditor(text: $taskDescription)
//						.scrollDisabled(true)
//						.scrollIndicators(.never)
					TextField("", text: $taskDescription, prompt: Text("Descrição"), axis: .vertical)
						.lineLimit(5...10)
					
				}
				.cornerRadius(5)
				.padding(.bottom, 14)

				
				DatePicker(selection: $taskDeadline) {
					Text("Selecione um Deadline")
				}
				.datePickerStyle(.automatic)
				
				HStack {
					VStack(alignment: .leading) {
						Text("Link do Protótipo")
							.font(.headline)
							.fontWeight(.semibold)
						
						TextField("Link", text: $prototypeLink)
							.textFieldStyle(.roundedBorder)
					}
					
					.padding(.trailing)
					
					Spacer()
					
					VStack(alignment: .leading) {
						Text("Link da Tarefa")
							.font(.headline)
							.fontWeight(.semibold)
						
						TextField("Link", text: $taskLink)
							.textFieldStyle(.roundedBorder)
					}
					
				}
				.padding(.bottom, 14)
				
				Text("Designers")
					.font(.headline)
					.fontWeight(.semibold)
					.padding(.bottom, 7)
				
				TextField("Designers", text: $taskDesigners)
					.padding(.bottom, 26)
				
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
						Task {
							await controller.createTask(taskName: taskName, taskDescription: taskDescription, taskLink: taskLink, taskPrototypeLink: prototypeLink, taskDesigners: taskDesigners, taskDeadline: taskDeadline)
							dismiss()
						}
						Aptabase.shared.trackEvent("Criou uma Task")
					}, label: {
						ZStack{
							Text("Criar Task")
						}
					})
				}
			}
			.padding()
		}.frame(minWidth: 511, minHeight: 433)

	}
}
