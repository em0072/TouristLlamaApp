//
//  FramedDatePickerView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct FramedDatePickerView: View {
    var title: String
    var placeholder: String
    @Binding var selection: Date?
    @State var isShown = false
    var minimumDate: Date
    var maximumDate: Date
    
    init(title: String, placeholder: String, selection: Binding<Date?>, minimumDate: Date? = nil, maximumDate: Date? = nil) {
        self.title = title
        self.placeholder = placeholder
        self._selection = selection
        self.minimumDate = minimumDate?.removeTimeStamp ?? Date.forward(.years(-1)).removeTimeStamp
        self.maximumDate = maximumDate?.removeTimeStamp ?? Date.forward(.years(150)).removeTimeStamp
    }

    var body: some View {
        VStack(spacing: 8) {
            FieldTitleView(title: title)
            
                FieldBackgroundView()
                    .overlay {
                        GeometryReader { proxy in
                            ZStack {
                                VStack {
                                    Spacer()
                                    placeholderView
                                    Spacer()
                                }
                                
                                datePickerView
                                    .scaleEffect(x: proxy.size.width / 130, y: proxy.size.height / 45)
                            }
                        }
                    }
        }
    }
}

extension FramedDatePickerView {
    
    private var placeholderView: some View {
        HStack(spacing: 0) {
            Text(fieldText)
                .font(.avenirBody.weight(.medium))
                .foregroundColor(textColor)
            Spacer()
            SelectorIconView()
                .iconText(textColor)
        }
        .padding(.horizontal, 10)
    }
    
    private var fieldText: String {
        if let date = selection {
            return date.toString(format: .ddMMMyyyy) ?? ""
        } else {
            return placeholder
        }
    }
    
    private var textColor: Color {
        isEmpty ? .Main.TLInactiveGrey : .Main.black
    }
    
    private var isEmpty: Bool {
        selection == nil
    }
    

    
    private var datePickerView: some View {
        DatePicker("", selection: unwrap(binding: $selection, fallback: Date()), in: minimumDate...maximumDate, displayedComponents: [.date])
            .accentColor(.Main.accentBlue)
            .labelsHidden()
            .id(selection)
            .colorMultiply(.clear)
    }
}

struct FramedDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        FramedDatePickerView(title: "Title", placeholder: "Select Date", selection: .constant(nil))
    }
}
