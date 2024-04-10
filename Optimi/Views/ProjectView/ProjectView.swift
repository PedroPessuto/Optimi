//
//  ProjectView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 10/04/24.
//

import SwiftUI

struct ProjectView: View {
    
    @Environment(GeneralController.self) private var generalController
    
    var body: some View {
        Text("\(generalController.project?.projectTasks.count ?? 129109381038018301)")
    
        
        oButton(text: "Criar Task") {
            Task {
                await generalController.createTask(taskName:"Teste")
            }
        }
    }
}

