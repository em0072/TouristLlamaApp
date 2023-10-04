//
//  AgrumeOverlayView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 03/10/2023.
//

import UIKit
import Agrume

class AgrumeOverlay: AgrumeOverlayView {
    
    var downloadButtonAction: (() -> Void)?

    // Create the download button
        private lazy var downloadButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
//            button.backgroundColor = .white
//            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    convenience init(downloadButtonAction: @escaping () -> Void) {
        self.init(frame: .zero)
        self.downloadButtonAction = downloadButtonAction
    }
    
        // Initialization
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        private func commonInit() {
            // Set the overlay color
//            self.backgroundColor = UIColor(white: 0, alpha: 0.7) // Adjust the alpha for transparency
            
            // Add the download button to the overlay
            self.addSubview(downloadButton)
            
            // Set the size and position of the download button
            NSLayoutConstraint.activate([
                downloadButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
                downloadButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20)
//                downloadButton.widthAnchor.constraint(equalToConstant: 100),
//                downloadButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        @objc func downloadButtonTapped() {
            downloadButtonAction?()
        }
    }
