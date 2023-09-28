//
//  Array+AdjacentElement.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 25/09/2023.
//

import Foundation

extension Array {
    
    func item(at index: Int) -> Element? {
        if index > 0 && index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
    
    func previous(from index: Int) -> Element? {
        let previousIndex = index - 1
        if previousIndex >= 0 {
            return self[previousIndex]
        } else {
            return nil
        }
    }
    
    func next(from index: Int) -> Element? {
        let nextIndex = index + 1
        if nextIndex < self.count {
            return self[nextIndex]
        } else {
            return nil
        }
    }
}
