//
//  Pickable.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

protocol Pickable: StringRepresentable, Localizable, Identifiable, Codable, Equatable, Hashable, CaseIterable where AllCases: RandomAccessCollection {}

extension Pickable {
    var id: Self { return self }
}

extension Pickable {
    var localizedValue: String {
        return self.rawValue
    }
}

//extension Pickable where Self: RawRepresentable, Self.RawValue == String {
//    var value: String {
//        return self.rawValue
//    }
//}

protocol StringRepresentable {
    var rawValue: String { get }
}

protocol Localizable {
    var localizedValue: String { get }
}

