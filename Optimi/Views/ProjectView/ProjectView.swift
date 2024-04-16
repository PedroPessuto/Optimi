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
	
	@State var tasksAreLoading: Bool = false
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
						pasteboard.writeObjects(["\(controller.project?.projectId?.recordName ?? "")" as NSString])
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
						Text(controller.project?.projectName ?? "")
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
					//Só manter esse if se ainda precisar de carregamento, se não tira
					if tasksAreLoading {
						List {
							Text("Carregando Tasks...")
						}
					}
					else {
						
						if (controller.project?.projectTasks.count == 0) {
							Text("Nenhuma Task Encontrada...")
							Spacer()
						}
						else {
							List {
                                ForEach((controller.project?.projectTasks.reversed() ?? []), id:\.taskId) { task in
									NavigationLink {

										if(controller.screen == .DeliveryView) {
											DeliveryView(task: task)
										}else{
											
											//Aq tem que arrumar a lógica de pai/filho
											TaskView(task: task)
												
										}
									} label: {
										//Criar TaskCard
										TaskCard(task: task)
											
									}
//									.simultaneousGesture(
//										TapGesture()
//											.onEnded {
//												_ in
//													controller.screen = .TaskView
//													
//											}
//									)
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
				CreateTaskView()
			}
			.navigationBarBackButtonHidden()
			.toolbar {
				ToolbarItem() {
					Button {
						controller.screen = .HomeView
					} label: {
						Image(systemName: "chevron.left")
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
		}
		.onAppear {
			Task {
				tasksAreLoading = true
				
				await controller.getTasksFromProject()
				
				tasksAreLoading = false
			}
		}
	}
}
