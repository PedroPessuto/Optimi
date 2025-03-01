//
//  OnBoardingView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import SwiftUI
struct OnboardingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(GeneralController.self) private var generalController
    
    @State var yourName: String = ""
    @State var cargoSelection: Roles = .Designer
    
    var body: some View {
        
#if os(macOS)
        NavigationStack {
            
            VStack(alignment: .leading) {
                
                Text("Olá! Este é o Optimi!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 5)
                
                //                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris lacinia sagittis leo, eget malesuada magna varius eget.")
                //                    .fixedSize(horizontal: false, vertical: true)
                //                    .padding(.bottom, 25)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Seu Nome")
                            .bold()
                        
                        TextField("Nome", text: $yourName)
                            .textFieldStyle(.roundedBorder)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .foregroundColor(.gray)
                            .tint(.gray)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Cargo")
                            .bold()
                        
                        Picker("", selection: $cargoSelection) {
                            ForEach(Roles.allCases) { role in
                                Text(String(describing: role))
                            }
                            
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding(.bottom)
                
                HStack {
                    Spacer()
                    
                    HStack {
                        
                        oButton(text: "Sair") {
                            dismiss()
                        }
                        .isDisabled(generalController.account == nil)
                        .variant(.outline)
                        
                        oButton(text: "Salvar Perfil") {
                            generalController.account = AccountModel(accountName: yourName, accountRole: cargoSelection)
                            dismiss()
                        }
                        .isDisabled(yourName == "")
                        .variant(.fill)
                        .keyboardShortcut(.defaultAction)
                    }
                }
            }
            .padding()
        }
        .frame(width: 448, height: 252)
        .onAppear {
            Task {
                await generalController.checkAccountStatus()
            }
            if let account = generalController.account {
                yourName = account.accountName
                cargoSelection = account.accountRole
            }
            else {
                yourName = ""
                cargoSelection = .Designer
            }
            
        }
#endif
#if os(iOS)
        NavigationStack{
            
            VStack(alignment: .leading){
					HStack {
						Spacer()
						
						Button {
							 generalController.account = AccountModel(accountName: yourName, accountRole: cargoSelection)
							 dismiss()
						} label: {
							 Text("Salvar Perfil")
						}
						.clipShape(.capsule)
						.disabled(yourName == "")
						
					}
                
                Text("Olá! Este é o Optimi!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 5)
                
//                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris lacinia sagittis leo, eget malesuada magna varius eget.")
//                    .fixedSize(horizontal: false, vertical: true)
//                    .padding(.bottom, 25)
                
                Form{
                    Section{
                        HStack{
                            Text("Seu Nome")
                                .bold()
                                .padding(.trailing,20)
                            
                            TextField("Nome", text: $yourName)
                        }
                        
                        Picker("", selection: $cargoSelection) {
                            ForEach(Roles.allCases) { role in
                                Text(String(describing: role))
                            }
                            
                        }
                        .pickerStyle(.segmented)
                    }
                }
            }
            .padding()
        }
		  .frame(minWidth: 511, minHeight: 350)
#endif
    }
}

#Preview {
    OnboardingView()
}
