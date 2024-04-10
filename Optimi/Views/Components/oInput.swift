//
//  oInput.swift
//  Optimi
//
//  Created by Pedro Pessuto on 10/04/24.
//

import SwiftUI

struct oInput: View {
    
    private var config: Config
    var text: String
    @Binding var binding: String
    
    var body: some View {
        
        TextField(text, text: $binding)
            .disabled(config.isDisabled)
#if os(macOS)
            .textFieldStyle(.roundedBorder)
#endif
#if os(iOS)
            .foregroundColor(Color(UIColor(red: 60/256, green: 60/256, blue: 67/256, alpha: 0.3)))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)))
            )
#endif
        
    }
    
    init(text: String, binding: Binding<String>) {
        self.config = Config()
        self.text = text
        self._binding = binding
    }
    
    public func isDisabled(_ value: Bool) -> oInput {
        var input = self
        input.config.isDisabled = value
        return input
    }
    
    private struct Config {
        var isDisabled: Bool = false
    }
}
