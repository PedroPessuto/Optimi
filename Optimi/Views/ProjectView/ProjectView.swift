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
                    .buttonStyle(PlainButtonStyle())
                    
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
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button {
                         //vai abrir um Menu com as duas opções
                         //Aqui vai ter a opção de Delete e Update
                    } label: {
                         Image(systemName: "ellipsis")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 5)
                }.padding()
                
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

#Preview {
    ProjectView()
}
