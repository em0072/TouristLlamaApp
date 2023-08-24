//
//  FramedTextField.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct FramedTextField: View {
    
    @Environment(\.isEnabled) private var isEnabled
        
    let title: String
    let prompt: String?
    @Binding var value: String
    let styles: Set<Style>
    let options: Set<Option>
    
    init(title: String?, prompt: String?, value: Binding<String>, styles: Set<Style>? = nil, options: Set<Option>? = nil) {
        self.title = title ?? ""
        self.prompt = prompt
        self._value = value
        self.styles = styles ?? []
        self.options = options ?? []
    }

    var body: some View {
        VStack(spacing: 8) {
            if !title.isEmpty {
                FieldTitleView(title: title)
            }
            
            FieldBackgroundView()
                .overlay {
                    textField
                }
        }
    }
}

extension FramedTextField {
    
    private var isLoading: Bool {
        for style in styles {
            if case .withLoading(let isLoading) = style {
                return isLoading
            }
        }
        return false
    }
    
    private var isShowingDeleteButton: Bool {
        for style in styles {
            if case .withDeleteButton = style {
                return !value.isEmpty
            }
        }
        return false
    }
    
    private var textAutocapitalisation: TextInputAutocapitalization? {
        for option in options {
            if case .autocapitalization(let textAutocapitalisation) = option {
                return textAutocapitalisation
            }
        }
        return nil
    }
    
    private var hasAutocorrection: Bool {
        for option in options {
            if case .autocorrection(let autocorrect) = option {
                return autocorrect
            }
        }
        return true
    }
    
    private var leftIcon: String? {
        for style in styles {
            if case .withLeftIcon(let leftIcon) = style {
                return leftIcon
            }
        }
        return nil
    }
    
    private var rightIcon: String? {
        for style in styles {
            if case .withRightIcon(let leftIcon) = style {
                return leftIcon
            }
        }
        return nil
    }

    private var leftButton: (icon: String, action: () -> Void)? {
        for style in styles {
            if case .withLeftButton(let icon, let action) = style {
                return (icon: icon, action: action)
            }
        }
        return nil
    }
    
    private var rightButton: (icon: String, action: () -> Void)? {
        for style in styles {
            if case .withRightButton(let icon, let action) = style {
                return (icon: icon, action: action)
            }
        }
        return nil
    }

            
    @ViewBuilder
    private var textField: some View {
        let promptText = prompt == nil ? nil : Text(prompt!).font(.avenirBody).foregroundColor(.Main.TLInactiveGrey)
        HStack(spacing: 12) {
            leftIconView
                .foregroundColor(.Main.black)

            TextField("", text: $value, prompt: promptText)
                .textInputAutocapitalization(textAutocapitalisation)
                .autocorrectionDisabled(!hasAutocorrection)
                .disabled(!isEnabled)
                .opacity(isEnabled ? 1 : 0.5)
                .tint(.Main.black)
            
            actionIconView
                .foregroundColor(.Main.black)
                .tint(.Main.black)
            
            rightIconView
                .foregroundColor(.Main.black)
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private var leftIconView: some View {
        if let leftButton {
            Button {
                leftButton.action()
            } label: {
                Image(systemName: leftButton.icon)
            }

        } else if let leftIcon {
            Image(systemName: leftIcon)
                .opacity(0.5)
        }
    }
    
    @ViewBuilder
    private var rightIconView: some View {
        if let rightButton {
            Button {
                rightButton.action()
            } label: {
                Image(systemName: rightButton.icon)
            }

        } else if let rightIcon {
            Image(systemName: rightIcon)
                .opacity(0.5)
        }
    }

    
    private var actionIconView: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else if isShowingDeleteButton {
                Button {
                    value.removeAll()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

extension FramedTextField {
    
    enum Style: Hashable {
        static func == (lhs: FramedTextField.Style, rhs: FramedTextField.Style) -> Bool {
            switch (lhs, rhs) {
            case (.withLoading, .withLoading): return true
            case (.withDeleteButton, .withDeleteButton): return true
            case (.withLeftIcon, .withLeftIcon): return true
            case (.withRightIcon, .withRightIcon): return true
            case (.withLeftButton, .withLeftButton): return true
            case (.withRightButton, .withRightButton): return true
            default: return false
            }
        }
        
        var hashValue: Int {
            switch self {
            case .withLoading: return 0
            case .withDeleteButton: return 1
            case .withLeftIcon: return 2
            case .withRightIcon: return 3
            case .withLeftButton: return 4
            case .withRightButton: return 5
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.hashValue)
        }
        
        case withLoading(Bool)
        case withDeleteButton
        case withLeftIcon(String)
        case withRightIcon(String)
        case withLeftButton(icon: String, action: () -> Void)
        case withRightButton(icon: String, action: () -> Void)
    }
    
    enum Option: Hashable {
        case autocapitalization(TextInputAutocapitalization)
        case autocorrection(Bool)
        
        var hashValue: Int {
            switch self {
            case .autocapitalization: return 0
            case .autocorrection: return 1
            }
        }
        
        static func == (lhs: FramedTextField.Option, rhs: FramedTextField.Option) -> Bool {
            switch (lhs, rhs) {
            case (.autocapitalization, .autocapitalization): return true
            case (.autocorrection, .autocorrection): return true
            default: return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.hashValue)
        }
    }
    
}

struct FramedTextField_Previews: PreviewProvider {
    static var previews: some View {
        FramedTextField(title: "Title",
                        prompt: "Prompt",
                        value: .constant("asd"),
                        styles: [.withDeleteButton, .withLoading(false), .withLeftIcon("magnifyingglass"), .withRightButton(icon: "square.and.arrow.up", action: {})])
            .padding()
    }
    
}
