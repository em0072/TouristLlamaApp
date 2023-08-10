//
//  FramedDataPickerView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct FramedPickerView<Data: Pickable>: View {
    
    var title: String
    var placeholder: String

    @Binding var selected: Data
    
    var emptyState: Data? = nil

    var body: some View {
        VStack(spacing: 8) {
            FieldTitleView(title: title)
            
            FieldBackgroundView()
                .overlay {
                    pickerView
                }
        }
    }
}

extension FramedPickerView {
    
    private var pickerView: some View {
                Menu {
                    ForEach(Data.allCases) { item in
                        if item != emptyState {
                            Button {
                                selected = item
                            } label: {
                                Label {
                                    Text(item == emptyState ? "" : item.rawValue.capitalized)
                                        .font(.avenirBody)
                                        .bold(item == selected)
                                } icon: {
                                    if item == selected {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    VStack {
                        Spacer()
                        HStack {
                            Text(isEmpty ? placeholder : selected.rawValue.capitalized)
                                .font(.avenirBody.weight(.medium))
                                .foregroundColor(color)
                            Spacer()
                            SelectorIconView()
                                .iconText(color)
                        }
                        Spacer()
                    }
                }
        .padding(.horizontal, 10)
        .accentColor(.Main.black)
    }
    
    private var color: Color {
        isEmpty ? .Main.TLInactiveGrey : .Main.black
    }
    
    private var isEmpty: Bool {
        if let emptyState = emptyState {
            return selected == emptyState
        } else {
            return false
        }
    }

}

struct FramedDataPickerView_Previews: PreviewProvider {
    static var previews: some View {
        FramedPickerView(title: "Title", placeholder: "Select Option", selected: .constant(Sex.none), emptyState: Sex.none)
    }
}
