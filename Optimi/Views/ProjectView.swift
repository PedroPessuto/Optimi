//
//  ProjectView.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 01/04/24.
//
import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct ProjectView: View {
	
	@Environment(GeneralController.self) private var controller
	@Environment(\.dismiss) private var dismiss
	
	@State var project: ProjectModel = ProjectModel(projectName: "Handy Project")
	
	@State var tasks: [TaskModel] = []
	@State var noTasksFound: Bool = false
	
	@State var createTaskSheetIsPresented: Bool = false
	@State var tokenWasCopied: Bool = false
	
	@State var taskSelected: TaskModel? = nil
	
	var body: some View {
		
#if os(iOS)
		NavigationStack {
			
			NavigationSplitView {
				
				VStack {
					
					// ======= HEADER =====
					HStack {
						Text(controller.viewController.project?.projectName ?? "Nome do Projeto")
							.font(.system(size: 23))
							.bold()
						
						Spacer()
						
						HStack {
							Button(action: {}) {
								Image(systemName: "line.3.horizontal.decrease.circle")
									.resizable()
									.frame(width: 17, height: 17)
							}
							
							Button(action: {createTaskSheetIsPresented.toggle()}) {
								Image(systemName: "plus")
									.resizable()
									.frame(width: 17, height: 17)
							}
						}
						
					}
					
					// ======= BODY =====
					ScrollView {
						LazyVStack {
							ForEach(controller.viewController.tasks.reversed(), id: \.self) { task in
								NavigationLink {
									TaskView(task: task)
								} label: {
									VStack (spacing: 0) {
										VStack (alignment: .leading, spacing: 10) {
											HStack {
												Text(task.taskName ?? "")
													.font(.system(size: 20))
													.foregroundStyle(controller.viewController.selectedTask?.id == task.id ? Color(UIColor(red: 1, green: 1, blue: 1, alpha: 1)) : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
											}
											
											//                                            HStack {
											//                                                Image(systemName: "person.fill")
											//                                                Text(task.designers?.joined(separator: ",") ?? "Não definido")
											//                                                    .font(.system(size: 20))
											//                                            }
											//                                            .foregroundStyle(controller.viewController.selectedTask?.id == task.id ? Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)) : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)))
											
											
										}
										.padding()
										.frame(maxWidth: .infinity)
										.background(controller.viewController.selectedTask?.id == task.id ? Color(.blue) : Color(.white))
										.multilineTextAlignment(.leading)
										
										
										Divider()
									}
									.frame(maxWidth: .infinity)
								}
								
								.simultaneousGesture(
									TapGesture()
										.onEnded { _ in
											controller.viewController.selectedTask = task
										}
								)
								
							}
							
							
							
						}
					}
					.frame(maxHeight: .infinity)
					.background(Color.white)
					.cornerRadius(10)
					
					
					Spacer()
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.padding()
				.background()
				.toolbar {
					
					ToolbarItemGroup(placement: .topBarTrailing) {
						Button(action: {}, label: {
							Text("Token")
							Image(systemName: "rectangle.portrait.on.rectangle.portrait")
						})
						
					}
					
					ToolbarItemGroup(placement: .topBarTrailing) {
						Button(action: {}, label: {
							Image(systemName: "ellipsis.circle")
						})
						
					}
					
				}
				
				
				
			} detail: {
				Text("Selecione ou crie uma Task para começar")
					.font(.largeTitle)
			}
			
		}
		.onAppear {
			Task {
				await controller.getInfo()
			}
		}
		.sheet(isPresented: $createTaskSheetIsPresented) {
			CreateTaskView()
		}
#endif
		
		
#if os(macOS)
		NavigationStack {
			if controller.currentScreen == "Project" {
				
				NavigationSplitView {
					
					VStack {
						
						Button {
							let pasteboard = NSPasteboard.general
							pasteboard.clearContents()
							pasteboard.writeObjects([project.projectKey! as NSString])
							
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
							Text(project.projectName)
								.font(.title3)
								.fontWeight(.semibold)
							
							Spacer()
							
							Button {
								createTaskSheetIsPresented.toggle()
							} label: {
								Image(systemName: "plus")
							}
							.buttonStyle(PlainButtonStyle())
						}
						.padding(.horizontal)
						if noTasksFound {
							List {
								Text("Nenhuma Task")
							}
						}
						else if tasks.isEmpty {
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
								ForEach(tasks.reversed(), id:\.self) { task in
									NavigationLink {
										TaskView(task: task)
											.onAppear {
												self.taskSelected = task
												controller.viewController.task = task
											}
									} label: {
										TaskCard(task: task)
										
									}
									
								}
							}
						}
					}
					.navigationSplitViewColumnWidth(min: 260, ideal: 280, max: 340)
					
				} detail: {
					Text("Selecione ou crie uma Task para começar")
						.font(.largeTitle)
				}
				.sheet(isPresented: $createTaskSheetIsPresented) {
					CreateTaskView()
				}
				.onAppear {
					Task {
						do {
							try await controller.getInfo()
							
							self.project = controller.viewController._project!
							self.tasks = controller.viewController.tasks
							
						} catch {
							print("Error fetching information: \(error)")
						}
					}
				}
			}
			else if controller.currentScreen == "Delivery" {
				DeliveryView(task: controller.viewController.task ??
								 TaskModel(id: 1, createdAt: Date.now, description: "Essa é a primeira task", prototypeLink: "link prototipo", taskLink: "link tarefa", status: "Ready for Dev!", taskName: "Task Uno!", designers: ["André Miguel", "Dani Brazolin Flauto"]))
			}
			
			
		}
		.onAppear {
			controller.currentScreen = "Project"
		}
		.navigationBarBackButtonHidden()
		
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button {
					controller.currentScreen = "Home"
				} label: {
					Image(systemName: "chevron.left")
				}
				.buttonStyle(PlainButtonStyle())
			}
		}
#endif
		
	}
}

#Preview {
	ProjectView()
}


//struct ProjectSidebarView: View {
//	var body: some View {
//		VStack {
//
//		}
//	}
//}
