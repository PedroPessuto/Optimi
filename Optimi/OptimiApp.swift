//
//  OptimiApp.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import SwiftUI
import Aptabase

@main
struct OptimiApp: App {
	
	init() {
		Aptabase.shared.initialize(appKey: "A-US-6406790195")
		Aptabase.shared.trackEvent("App_started")
	}
	
    var body: some Scene {
        
        @State var generalController: GeneralController = GeneralController()
        
        WindowGroup {
            ContentView()
                .environment(generalController)
        }
    }
}
