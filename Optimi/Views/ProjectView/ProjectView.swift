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
        
        NavigationSplitView {
            
            VStack {
                
                HStack{
                    Button {
                        controller.screen = .HomeView
                    } label: {
#if os(macOS)
                        Image(systemName: "chevron.left")
#endif
#if os(iOS)
                        Image(systemName: "house")
#endif
                    }
                    #if os(macOS)
                    .foregroundColor(.accent)
                    .buttonStyle(PlainButtonStyle())
#endif
                    
                    Spacer()
                    
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
                        .padding(.vertical, 12)
                    }
                    #if os(macOS)
                    .foregroundColor(.accent)
                    .buttonStyle(PlainButtonStyle())
#endif
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            Task {
                                await controller.deleteProject()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Deletar Projeto")
                            }
                            .foregroundStyle(.red)
                        }
                        
                    } label: {
                         Image(systemName: "ellipsis.circle")
                    }
                    #if os(macOS)
                    .foregroundStyle(.accent)
                    .buttonStyle(PlainButtonStyle())
//                    .menuStyle(.borderlessButton)
                    .frame(width: 15)
                    #endif
                    
                }
                .padding()
                
                HStack {
                    Text(controller.project?.projectName ?? "")
#if os(macOS)
                        .font(.title3)
#endif
#if os(iOS)
                        .font(.title)
#endif
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    if(controller.account?.accountRole == .Designer){
                        Button {
                            createTaskSheetIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                        }
#if os(macOS)
                        .buttonStyle(PlainButtonStyle())
#endif
                    }
                }
                .padding(.horizontal)
                if tasksAreLoading {
                    List {
                        Text("Carregando Tasks...")
                    }
                }
                else {
                    
                    if (controller.project?.projectTasks.count == 0) {
                        Text("Nenhuma Task Encontrada...")
                            .padding(.top, 5)
                        Spacer()
                    }
                    else {
                        List {
                            ForEach((controller.project?.projectTasks.reversed())!, id:\.taskId) { task in
                                NavigationLink {
                                    
                                    if(controller.screen == .DeliveryView) {
                                        DeliveryView(task: task)
                                    }else{
                                        
                                        TaskView(task: task)
                                    }
                                } label: {
                                    
                                    TaskCard(task: task)
                                }
                            }
                        }
                    }
                }
            }
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
        .onAppear {
            Task {
                tasksAreLoading = true
                
                await controller.getTasksFromProject()
                
                tasksAreLoading = false
            }
        }
    }
}

