//
//  InitView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 28/03/24.
//

import SwiftUI

struct InitView: View {
	@Environment(GeneralController.self) private var generalController
	@State var OnboardingViewIsPresented: Bool = true
	
	var body: some View {
		NavigationStack{
			if generalController.currentScreen == "Project"{
				ProjectView()
			}
			else if generalController.currentScreen == "Home"{
				HomeView()
			}
			
			//            else if generalController.currentScreen == "Delivery"{
			//                DeliveryView()
			//            }
			
		}
		.sheet(isPresented: $OnboardingViewIsPresented) {
			OnboardingView()
		}
	}
}
