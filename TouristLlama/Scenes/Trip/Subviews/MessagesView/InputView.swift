//
//  InputView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 25/09/2023.
//

import SwiftUI
import InputBarAccessoryView

final class InputBarView: InputBarAccessoryView {
    
    let mediaButtonSide: CGFloat = 34
    let sendButtonSide: CGFloat = 34
    let sendButtonSideSpacing: CGFloat = 4

    var onMediaButtonPress: (() -> Void)?
    
    convenience init(onMediaButtonPress: @escaping () -> Void) {
        self.init()
        self.onMediaButtonPress = onMediaButtonPress
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mediaButton: InputBarButtonItem = {
        return InputBarButtonItem()
            .configure {
                $0.setSize(CGSize(width: self.mediaButtonSide, height: self.mediaButtonSide), animated: false)
                $0.setTitle(nil, for: .normal)
                $0.image = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                $0.imageView?.layer.opacity = 1
                $0.layer.cornerRadius = self.mediaButtonSide / 2
                $0.backgroundColor = UIColor.systemGray3
            }.onTouchUpInside { 
                if let view = $0.inputBarAccessoryView as? InputBarView {
                    view.onMediaButtonPress?()
                }
        }
    }()
        
    func configure() {
        setupBackground()
        setupSendButton()
        setupMediaButton()
        setupInputTextView()
    }
    
    private func setupBackground() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.backgroundColor = .clear
        backgroundView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        backgroundColor = .clear
    }
    
    private func setupSendButton() {
        rightStackView.bounds = rightStackView.bounds.offsetBy(dx: 0, dy: 4)
        setRightStackViewWidthConstant(to: sendButtonSide + sendButtonSideSpacing, animated: false)
        
        sendButton.setSize(CGSize(width: sendButtonSide, height: sendButtonSide), animated: false)
        sendButton.setTitle(nil, for: .normal)
        sendButton.image = UIImage(systemName: "arrow.up")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        sendButton.layer.cornerRadius = sendButtonSide / 2
        sendButton.backgroundColor = UIColor(Color.Main.accentBlue)
        sendButton.isEnabled = false
        sendButton.layer.opacity = 0
        setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(sendButtonSideSpacing)], forStack: .right, animated: false)
    }
    
    private func setupMediaButton() {
        leftStackView.bounds = leftStackView.bounds.offsetBy(dx: 0, dy: 4)
        setLeftStackViewWidthConstant(to: mediaButtonSide, animated: false)
        setStackViewItems([mediaButton], forStack: .left, animated: false)
    }
    
    private func setupInputTextView() {
        
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.borderColor = UIColor.systemGray3.cgColor
        inputTextView.layer.cornerRadius = 20
        inputTextView.layer.masksToBounds = true

        middleContentViewPadding.left = 8
        middleContentViewPadding.right = -(sendButtonSide + sendButtonSideSpacing)
        middleContentViewPadding.top = 0
        middleContentViewPadding.bottom = 0
        
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: sendButtonSide + sendButtonSideSpacing)
//        inputTextView.
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 10, left: 17, bottom: 10, right: sendButtonSide + sendButtonSideSpacing)

    }
 
    override func inputTextViewDidBeginEditing() {
        
    }
    
    override func inputTextViewDidChange() {
        super.inputTextViewDidChange()
        sendButton.isEnabled = !inputTextView.text.isEmpty
        UIView.animate(withDuration: 0.2) {
            self.sendButton.layer.opacity = self.inputTextView.text.isEmpty ? 0 : 1
        }
    }

}

//#Preview {
//    let button = iMessageInputBar()
////    button.setTitle("UIKit", for: .normal)
//    
//    return button
//}
