//
//  OnboardingView.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 28/03/24.
//

import SwiftUI

struct OnboardingView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	@Environment(GeneralController.self) private var generalController
	
	@State var yourName: String = ""
	@State var cargoSelection: String = ""
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				
				title
				
				description
				
				HStack {
					
					nameTextField
					
					cargoPicker
				}
				.padding(.bottom)
				
				HStack {
					
					Spacer()
					
					HStack {
						
						leaveButton
						
						saveButton
					}
				}
			}
			.padding()
		}
		.frame(width: 448, height: 252)
	}
}

#Preview {
	OnboardingView()
}

extension OnboardingView {
	
	private var title: some View {
		Text("Olá! Este é o Handy!")
			.font(.largeTitle)
			.bold()
			.padding(.bottom, 5)
	}
	
	private var description: some View {
		Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris lacinia sagittis leo, eget malesuada magna varius eget.")
			.fixedSize(horizontal: false, vertical: true)
			.padding(.bottom, 25)
	}
	
	private var nameTextField: some View {
		VStack(alignment: .leading) {
			Text("Seu Nome")
				.bold()
			TextField("Placeholder", text: $yourName)
				.textFieldStyle(.roundedBorder)
		}
	}
	
	private var cargoPicker: some View {
		VStack(alignment: .leading) {
			Text("Cargo")
				.bold()
			Picker("", selection: $cargoSelection) {
				Text("Designer").tag("Designer")
				Text("Developer").tag("Developer")
			}
			.pickerStyle(.segmented)
		}
	}
	
	private var leaveButton: some View {
		Button {
			dismiss()
		} label: {
			Text("Sair")
		}
		.keyboardShortcut(.cancelAction)
	}
	
	private var saveButton: some View {
		Button {
			generalController.nome = yourName
			generalController.cargo = cargoSelection == "Designer" ? .Designer : .Developer
			print(cargoSelection)
			dismiss()
		} label: {
			Text("Salvar Perfil")
		}
		.keyboardShortcut(.defaultAction)
	}
}
