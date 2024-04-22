//
//  TaskView.swift
//  Optimi
//
//  Created by Marina Martin && Paulo SOnzizni on 11/04/24.
//

import SwiftUI

struct TaskView: View {
    
    @Environment(GeneralController.self) var controller
    
    var task: TaskModel
    
    @State var currentScreen: ScreenNames = .TaskView
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy - hh:mm"
        return formatter
    }
    
    var body: some View {
        NavigationStack{
            HStack(alignment: .center){
                VStack(alignment: .leading) {
                    StatusPill(status: task.taskStatus!)
                        .padding(.top)
                    
                    Text(task.taskName)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    
                    Text(task.taskDescription!)
                        .padding(.bottom, 9)
                        .font(.body)
                        .frame(width: 200, alignment: .leading)
                    
                    
                    HStack{
                        if let date = task.taskDeadline {
                            Text("Deadline: ")
                            Text("\(formatter.string(from: date))")
                        }
                    }.padding(.bottom, 25)
                        .font(.body)
                        .bold()
                    
                    Button {
                        Task{
                            await controller.changeTaskStatus(task, .EmAndamento)
                        }
                    } label: {
                        Text("Entrar na Task")
                    }
                    .keyboardShortcut(.defaultAction)
                    .padding(.bottom, 25)
#if os(iOS)
                    .buttonStyle(.borderedProminent)
#endif
						 if (task.taskPrototypeLink != "") || (task.taskLink != "") {
							 Text("Links Importantes")
								  .font(.title)
						 }
                    
                    
						 HStack{
							 if let link = task.taskPrototypeLink {
								 if link != "" {
									 Image(systemName: "link")
									 Link("Protótipo", destination: URL(string: link)!)
										 .padding(.trailing, 50)
								 }
							 }
							 
						 }.font(.title2)
                        .foregroundStyle(Color.accentColor)
                    
                    HStack{
							  if let link = task.taskLink {
								  if link != ""{
									  Image(systemName: "link")
									  Link("Tarefa", destination: URL(string: link)!)
								  }
							  }
                        
                    }.font(.title2)
                        .padding(.bottom, 40)
                        .foregroundStyle(Color.accentColor)
                    
                    Text("Responsáveis")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)
                    HStack{
                        VStack(alignment: .leading){
                            Text("Designers")
                                .font(.title2)
                            Text(task.taskDesigners!)
                        }.padding(.trailing, 20)
                        
                        VStack(alignment: .leading){
                            Text("Developers")
                                .font(.title2)
                            Text(task.taskDevelopers ?? "Nenhum dev associado...")
                            //Aqui tem que trocar pra developers
                        }
                    }
                    
                    Spacer()
                }
                Spacer()
            }
#if os(macOS)
            .padding(.leading, 35)
            .padding(.trailing, 35)
            .padding(.bottom, 4)
            .padding(.top, 20)
#endif
#if os(iOS)
            .padding(.leading, 30)
#endif
            .background(imageBackground)
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Picker("CurrentScreen", selection: $currentScreen) {
                        Text("Task").tag(ScreenNames.TaskView)
                        Text("Feedback").tag(ScreenNames.DeliveryView)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: currentScreen) {
                        controller.screen = currentScreen
                    }
                }
            }
        }
#if os(macOS)
        .frame(minWidth: 620, maxWidth: .infinity)
#endif
    }
}

//#Preview {
//	 TaskView(task: TaskModel(createdAt: "10/05/2024", description: "Implementar telas necessárias para inclusão e interação com o CloudKit para trazer melhor usabilidade para o nosso usuário que irá trabalhar com informações no servidor", prototypeLink: "gdfdfsd", taskLink: "gdfdfd", status: "Ready for Dev", taskName: "Implementação CloudKit", designers: "André Arteca, Juliana Machado, Daniela Flauto"))
//}

extension TaskView {
    func background(for string: String) -> String {
        switch string {
        case "Ready for Dev":
            return "Dev"
        case "Aprovada":
            return "Aprovada"
        case "Revisão Pendente":
            return "Revisao"
        case "Reprovada":
            return "Reprovada"
        case "Em Andamento":
            return "Andamento"
        default:
            return ""
        }
    }
}

extension TaskView {
    private var imageBackground: some View {
        Image(background(for: task.taskStatus!))
            .resizable()
#if os(iOS)
            .scaledToFill()
#endif
    }
}
