//
//  InfoMessageCell.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/09/2023.
//

import UIKit
import SwiftUI
import MessageKit

class InfoMessageCell: UICollectionViewCell {
    
    static var font: UIFont = UIFont.systemFont(ofSize: 12, weight: .bold)
    private let backgroundPadding: CGSize = .init(width: 14, height: 8)
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(Color.Main.black)
        label.font = InfoMessageCell.font
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .red
        return label
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    private let backgroundColorView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//        blurEffectView.frame = button.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.isUserInteractionEnabled = false // Allows button to receive the touch events
//        button.addSubview(blurEffectView)
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundColorView)
        contentView.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        backgroundColorView.topAnchor.constraint(equalTo: label.topAnchor, constant: -backgroundPadding.height).isActive = true
        backgroundColorView.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -backgroundPadding.width).isActive = true
        backgroundColorView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: backgroundPadding.height).isActive = true
        backgroundColorView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: backgroundPadding.width).isActive = true

//        contentView.backgroundColor = .yellow

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = contentView.bounds
        label.frame = contentView.bounds
    }

    func configure(with text: String) {
        label.text = text
    }

}

open class CustomMessageSizeCalculator: MessageSizeCalculator {
    
    let text: String
    private let cellPadding: CGSize = .init(width: 12, height: 6)

    public init(text: String, layout: MessagesCollectionViewFlowLayout? = nil) {
        self.text = text
        super.init(layout: layout)
    }
    
    open override func messageContainerSize(for _: MessageType, at _: IndexPath) -> CGSize {
        guard let layout = layout else { return .zero }
        let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
        let contentInset = layout.collectionView?.contentInset ?? .zero
        let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
        let width = collectionViewWidth - inset
        let font: UIFont = InfoMessageCell.font

        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        let boundingRect = attributedText.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                       options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                       context: nil)

        let height = ceil(boundingRect.height)

        return CGSize(width: collectionViewWidth - (cellPadding.width * 2), height: height + (cellPadding.height * 2))
    }
}
