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
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(alignment: .leading){
                    Image(background(for: task.taskStatus!))
                        //.frame(minWidth: 887, maxWidth: 1920, minHeight: 426, maxHeight: 1080)
                        .resizable()
                }
                
                HStack(alignment: .center){
                    VStack(alignment: .leading) {
                        StatusPill(status: task.taskStatus!)
                            .padding(.top)
                        
                        Text(task.taskName)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        VStack{
                            Text(task.taskDescription!)
                                .padding(.bottom, 9)
                                .font(.body)
                        }.frame(width: 200)
                        
                        HStack{
                            Text("Deadline: ")
                            Text("\(task.taskCreatedAt)")
                        }.padding(.bottom, 25)
                            .font(.body)
                            .bold()
                        
                        Button {
                            Task{
                                //Adiciona Nome da pessoa na String de Dev se Dev e Designer se Designer
                            }
                        } label: {
                            Text("Entrar na Task")
                        }
                        .keyboardShortcut(.defaultAction)
                        .padding(.bottom, 25)
                        
                        Text("Links Importantes")
                            .font(.title)
                        
                        HStack{
                            Image(systemName: "link")
                                .foregroundStyle(.blue)
                            Link("Protótipo", destination: URL(string: task.taskPrototypeLink!)!)
                                .padding(.trailing, 50)
                            
                        }.font(.title2)
                        
                        HStack{
                            Image(systemName: "link")
                                .foregroundStyle(.blue)
                            Link("Tarefa", destination: URL(string: task.taskLink!)!)
                        }.font(.title2)
                            .padding(.bottom, 40)
                        
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
                                Text(task.taskDesigners!)
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
                .padding(.leading,30)
#endif
            }
            
            
            .toolbar {
                #if os(iOS)
                ToolbarItem() {
                    Button {
                        controller.screen = .HomeView
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                #endif
                
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
        //		  .scaledToFill()
#if os(macOS)
        .frame(minWidth: 620, maxWidth: .infinity)
#endif
        //		  #if os(iOS)
        //		  .frame(minWidth: 500, maxWidth: 600, minHeight: 500, maxHeight: 700)
        //		  #endif
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
