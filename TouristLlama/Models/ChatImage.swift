//
//  ChatMessageMediaitem.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 29/09/2023.
//

import SwiftUI
import MessageKit

struct ChatMessageMediaItem: MediaItem, Transferable {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize = CGSize(width: 250, height: 250)

    init(url: URL? = nil, image: UIImage? = nil, placeholderImage: UIImage, size: CGSize) {
        self.url = url
        self.image = image
        self.placeholderImage = placeholderImage
        self.size = size
    }
    
    init() {
        self.url = nil
        self.image = nil
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
    }

    init(url: URL?, image: UIImage) {
        self.url = url
        self.image = image
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
    }

    init(url: URL?) {
        self.url = url
        self.image = nil
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
    }

    init(image: UIImage?) {
        self.url = nil
        self.image = image
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
    }
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let image = UIImage(data: data) else {
                throw CustomError(text: "Image import failed")
            }
            return ChatMessageMediaItem(image: image)
        }
    }
}

extension ChatMessageMediaItem: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(image)
    }
}

//struct ChatImage: Transferable {
//    let image: UIImage
//    
//    static var transferRepresentation: some TransferRepresentation {
//        DataRepresentation(importedContentType: .image) { data in
//        #if canImport(AppKit)
//            guard let nsImage = NSImage(data: data) else {
//                throw CustomError(text: "Image import failed")
//            }
//            let image = Image(nsImage: nsImage)
//            return ChatImage(image: image)
//        #elseif canImport(UIKit)
//            guard let image = UIImage(data: data) else {
//                throw CustomError(text: "Image import failed")
//            }
////            let image = Image(uiImage: uiImage)
//            return ChatImage(image: image)
//        #else
//            throw CustomError(text: "Image import failed")
//        #endif
//        }
//    }
//}
