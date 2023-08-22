//
//  UIimage+resized.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 22/08/2023.
//

import Foundation
import UIKit

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    
        func resized(to height: CGFloat) -> UIImage {
            let scale = height / self.size.height
            let newWidth = self.size.width * scale
            let newSize = CGSize(width: newWidth, height: height)
            let renderer = UIGraphicsImageRenderer(size: newSize)

            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
    
    convenience init?(data: Data?) {
        if let data = data {
            self.init(data: data)
        } else {
            return nil
        }
    }

}
