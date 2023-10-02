//
//  MessagesView+InputBarAccessoryViewDelegate.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 29/09/2023.
//

import Foundation
import InputBarAccessoryView
import MessageKit

extension MessagesView.Coordinator: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    onSendButtonPress(text)
    inputBar.inputTextView.text = ""
  }

}
