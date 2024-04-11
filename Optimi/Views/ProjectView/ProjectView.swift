//
//  ProjectView.swift
//  Optimi
//
//  Created by Marina Martin on 10/04/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ProjectView: View {
	 
	 @Environment(GeneralController.self) private var controller
	 @Environment(\.dismiss) private var dismiss
	 
	 //Variaveis Mockadas
	 @State var project: String = "Nome do projeto"
	 @State var projectKey: String = "1,2,3"
	 @State var tasks: [TaskModel] = [/*TaskModel(createdAt: "10/05/2024", description: "Implementar telas necessárias para inclusão e interação com o CloudKit para trazer melhor usabilidade para o nosso usuário que irá trabalhar com informações no servidor", prototypeLink: "gdfdfsd", taskLink: "gdfdfd", status: "Ready for Dev", taskName: "Implementação CloudKit", designers: "André Arteca, Juliana Machado, Daniela Flauto"), TaskModel(createdAt: "10/05/2024", description: "Implementar telas necessárias para inclusão e interação com o CloudKit para trazer melhor usabilidade para o nosso usuário que irá trabalhar com informações no servidor", prototypeLink: "gdfdfsd", taskLink: "gdfdfd", status: "Em Andamento", taskName: "Implementação CloudKit", designers: "André Arteca, Juliana Machado, Daniela Flauto")*/]
	 @State var noTasksFound: Bool = false
	 
	 @State var createTaskSheetIsPresented: Bool = false
	 @State var tokenWasCopied: Bool = false
	 @State var taskSelected: TaskModel? = nil
	 
	 var body: some View {
		  
		  
//#if os(macOS)
		  NavigationStack {
				
				NavigationSplitView {
					 
					 VStack {
						  
						  Button {
#if os(macOS)
								let pasteboard = NSPasteboard.general
								pasteboard.clearContents()
								//Aqui tem que estar a Key do projeto
								pasteboard.writeObjects([projectKey as NSString])
#endif
								withAnimation(.easeInOut(duration: 0.5)) {
									 tokenWasCopied.toggle()
									 
									 DispatchQueue.main.asyncAfter(deadline: .now()+5) {
										  withAnimation(.easeInOut(duration: 0.5)) {
												tokenWasCopied.toggle()
										  }
									 }
								}
						  } label: {
								
								HStack {
									 Text("Token")
									 Image(systemName: "doc.on.doc")
									 if tokenWasCopied {
										  Image(systemName: "checkmark")
									 }
								}
								.foregroundStyle(.secondary)
								.padding(.vertical, 12)
						  }
						  .buttonStyle(PlainButtonStyle())
						  
						  HStack {
								Text(project)
									 .font(.title3)
									 .fontWeight(.semibold)
								
								Spacer()
								
								Button {
									 //aqui leva pra sheet de criar Task
								} label: {
									 Image(systemName: "plus")
								}
								.buttonStyle(PlainButtonStyle())
						  }
						  .padding(.horizontal)
						  //Só manter esse if se ainda precisar de carregamento, se não tira
						  if tasks.isEmpty {
								List {
									 Text("Carregando Tasks...")
								}
								.onAppear {
									 DispatchQueue.main.asyncAfter(deadline: .now()+10) {
										  if tasks.isEmpty {
												noTasksFound.toggle()
										  }
									 }
								}
						  }
						  else {
								List {
									 ForEach(tasks.reversed(), id:\.taskId) { task in
										  NavigationLink {
												//Aqui tem que levar para a TaskView de cada Task
												//  TaskView(task: task)
												//  .onAppear {
												//                                                self.taskSelected = task
												//                                                controller.viewController.task = task
												//                                            }
										  } label: {
												//Criar TaskCard
												TaskCard(task: task)
										  }
										  
									 }
								}
						  }
					 }
//#if os(iOS)
//            .frame(width: 500)
//#endif
#if os(macOS)
					 .navigationSplitViewColumnWidth(min: 260, ideal: 280, max: 340)
#endif
				} detail: {
					 Text("Selecione ou crie uma Task para começar")
						  .font(.largeTitle)
				}
				.sheet(isPresented: $createTaskSheetIsPresented) {
					 //Sheet de Criar Task Aqui
					 //CreateTaskView()
				}
				.navigationBarBackButtonHidden()
				.toolbar {
					 ToolbarItem(placement: .cancellationAction) {
						  Button {
								//Aqui tem que voltar pra home do projeto onde o usuário seleciona a tela
						  } label: {
								Image(systemName: "chevron.left")
						  }
						  .buttonStyle(PlainButtonStyle())
					 }
				}
		  }
	 }
}

#Preview {
	 ProjectView()
}
