//
//  OptimiApp.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import SwiftUI
import SwiftData

@main
struct OptimiApp: App {
    
    @State var generalController: GeneralController = GeneralController()
//    var container: ModelContainer
//
//    init() {
//        do {
//            let schema = Schema([ProjectModel.self, TaskModel.self, DeliveryModel.self, FeedbackModel.self, PersonModel.self])
//            let config = ModelConfiguration(schema: schema, cloudKitDatabase: .private(""))
//            container = try ModelContainer(for: schema, configurations: config)
//        } catch {
//            fatalError("Failed to configure SwiftData container.")
//        }
//    }
    
    var body: some Scene {
        WindowGroup {
			  FastingHistoryView()
        }
        .environment(generalController)
//        .modelContainer(container)
    }
}
