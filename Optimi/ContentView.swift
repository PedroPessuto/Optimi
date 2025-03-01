//
//  ContentView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import SwiftUI

struct ContentView: View {
        
    @Environment(GeneralController.self) private var controller
    
    var body: some View {
        if (controller.screen == .HomeView || controller.screen == .ProjectNotFoundView ) {

			 HomeView()
        }
        else {
			  ProjectView()
        }
        
    }
}

