//
//  SwitchToggleStyle.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import SwiftUI

struct SwitchToggleStyle: ToggleStyle {
    var onColor = Color.Main.accentBlue
    var offColor = Color.Main.TLBackgroundActive
    var thumbOnColor = Color.Main.TLStrongWhite
    var thumbOffColor = Color.Main.TLInactiveGrey
    
    enum Size {
        case standard
        case small
    }
    
    @State var dragInitialState: Bool = false
    @State private var isReadyToSwipe: Bool = false
    @State var dragStarted: Bool = false
    
    let size: Size
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            
            configuration.label
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 18, style: .circular)
                .foregroundStyle(.shadow(.inner(color: .black.opacity(0.1), radius: 3, x: 0, y: 0)))
                .foregroundColor(configuration.isOn ? onColor : offColor)
                .frame(width: bodySize.width, height: bodySize.height)
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                                .fill(configuration.isOn ? thumbOnColor : thumbOffColor)
                                .shadow(radius: 1, x: 0, y: 1)
                                .offset(x: offset(isOn: configuration.isOn))
                                .frame(width: circleSize.width,
                                       height: circleSize.height)
                    })
                .gesture(
                                        DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            isReadyToSwipe = true
                                            dragStarted = abs(value.translation.width) > 1
                                            if dragInitialState {
                                                if value.translation.width < -20 {
                                                    configuration.isOn = !dragInitialState
                                                } else {
                                                    configuration.isOn = dragInitialState
                                                }
                                            } else {
                                                if value.translation.width > 20 {
                                                    configuration.isOn = !dragInitialState
                                                } else {
                                                    configuration.isOn = dragInitialState
                                                }
                                            }
                                        }
                                        .onEnded({ value in
                                            if !dragStarted {
                                                configuration.isOn.toggle()
                                            }
                                            isReadyToSwipe = false
                                            dragStarted = false
                                            dragInitialState = configuration.isOn
                                        })
                )
                .onAppear {
                    dragInitialState = configuration.isOn
                }
                .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                .animation(.easeOut(duration: 0.2), value: isReadyToSwipe)
        }
    }
}

extension SwitchToggleStyle {
    
    private func offset(isOn: Bool) -> CGFloat {
        let multiplyer: CGFloat = isOn ? 1 : -1
        var offset: CGFloat
        switch size {
        case .standard:
            offset = isReadyToSwipe ? 7 : 10
        case .small:
            offset = isReadyToSwipe ? 4 : 7
        }
        offset *= multiplyer
        return offset
    }
    
    private var bodySize: CGSize {
        switch size {
        case .standard:
            return CGSize(width: 60, height: 36)
        case .small:
            return CGSize(width: 38, height: 23)
        }
    }

    private var circleSize: CGSize {
        switch size {
        case .standard:
            return CGSize(width: isReadyToSwipe ? 30 : 26, height: 26)
        case .small:
            return CGSize(width: isReadyToSwipe ? 20 : 16, height: 16)
        }
    }
}

//struct SwitchToggleStyle_Previews: PreviewProvider {
//
//    static var previews: some View {
//        Toggle(isOn: .constant(true) ) {
//            Text("Toggle")
//        }
//        .toggleStyle(SwitchToggleStyle(size: .standard))
//    }
//}
//

struct SwitchToggleStyleOnRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterView()
        }
    }
}

