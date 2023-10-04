//
//  MessageSwiftUIVC.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 29/09/2023.
//

import UIKit
import MessageKit
import Agrume
import Kingfisher
import OSLog

final class MessageSwiftUIVC: MessagesViewController {
    
    private var scrollToBottomButton: UIButton?
    private var isScrollToBottomButtonVisible: Bool = false
    private var isUserDragging: Bool = false
    
    var agrume: Agrume?
    
    var messages: [ChatMessage] {
        didSet {
            mediaMessages = messages.filter({ $0.type == .userImage })
        }
    }
    var mediaMessages: [ChatMessage] = []
    let onMessageAppear: (Int) -> Void
    let onMessageDisappear: (Int) -> Void
    
    init(messages: [ChatMessage],
         onMessageAppear: @escaping (Int) -> Void,
         onMessageDisappear: @escaping (Int) -> Void) {
        self.messages = messages
        self.onMessageAppear = onMessageAppear
        self.onMessageDisappear = onMessageDisappear
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollToBottomButton()
//        let downloadItem = UIEditMenuInteraction(delegate: self)
        
    }
    
    @objc func downloadImage() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
        messagesCollectionView.scrollToLastItem(animated: false)
    }
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
      if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
          layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
          layout.textMessageSizeCalculator.incomingAvatarPosition = .init(vertical: .messageTop)
          layout.textMessageSizeCalculator.avatarLeadingTrailingPadding = 12
          layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
          
          layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
          layout.photoMessageSizeCalculator.incomingAvatarPosition = .init(vertical: .messageTop)
          layout.photoMessageSizeCalculator.avatarLeadingTrailingPadding = 12

      }
      showMessageTimestampOnSwipeLeft = true
  }
       
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        onMessageAppear(indexPath.section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        onMessageDisappear(indexPath.section)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        let lowestPoint = scrollView.contentSize.height - scrollView.bounds.height + scrollView.adjustedContentInset.bottom
        let difference = lowestPoint - scrollView.contentOffset.y
        let userScrolledABit = difference > 75 && isUserDragging
        var scrollViewIsScrolledToTop = false
        scrollViewIsScrolledToTop = scrollView.contentOffset.y < -95 && scrollView.contentSize.height > scrollView.bounds.height

        if userScrolledABit || scrollViewIsScrolledToTop {
            setScrollToBottomButton(visible: true)
        } else {
            setScrollToBottomButton(visible: false)
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDragging(scrollView)
        isUserDragging = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        isUserDragging = false
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: willDecelerate)
        if !willDecelerate {
            isUserDragging = false
        }
    }
    
    private func addScrollToBottomButton() {
        let button = UIButton(type: .system)
        let buttonSide: CGFloat = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.opacity = 0
        // Applying Background Material
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = button.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false // Allows button to receive the touch events
        button.addSubview(blurEffectView)
        
        // Setting the Image with SFSymbol
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false // Allows button to receive the touch events
        let image = UIImage(systemName: "chevron.down")
        imageView.image = image
        blurEffectView.contentView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor).isActive = true

        // Making the Button Round
        button.layer.cornerRadius = buttonSide / 2 // assuming the button size is 50x50
        button.clipsToBounds = true

        // Inserting Button
        self.view.addSubview(button)
        
        // Applying Constraint
        button.widthAnchor.constraint(equalToConstant: buttonSide).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonSide).isActive = true
        button.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true

        // Adding Action
        button.addTarget(self, action: #selector(scrollToBottomButtonAction), for: .touchUpInside)
        scrollToBottomButton = button
    }
    
    @objc private func scrollToBottomButtonAction() {
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    
    private func setScrollToBottomButton(visible: Bool) {
        guard isScrollToBottomButtonVisible != visible else { return }
        isScrollToBottomButtonVisible = visible
        
        let opacity: Float = visible ? 1 : 0
        let isEnabled = visible ? true : false
        scrollToBottomButton?.isUserInteractionEnabled = isEnabled
        UIView.animate(withDuration: 0.2) {
            self.scrollToBottomButton?.layer.opacity = opacity
        }
    }
}

           
extension MessageSwiftUIVC: AgrumeDataSource {
    var numberOfImages: Int {
        mediaMessages.count
    }
    
    func image(forIndex index: Int, completion: @escaping (UIImage?) -> Void) {
        Logger.viewCycle.info("Show Image at index \(index)")
        let message = mediaMessages[index]
        let mediaItem = message.image
        if let image = mediaItem?.image {
            completion(image)
        } else if let url = mediaItem?.url {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResource):
                    completion(imageResource.image)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    
}
