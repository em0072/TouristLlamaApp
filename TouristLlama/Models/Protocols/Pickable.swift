//
//  Pickable.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

protocol Pickable: StringRepresentable, Identifiable, Codable, Equatable, CaseIterable where AllCases: RandomAccessCollection {}

extension Pickable {
    var id: Self { return self }
}

extension Pickable where Self: RawRepresentable, Self.RawValue == String {
    var value: String {
        return self.rawValue
    }
}

protocol StringRepresentable {
    var rawValue: String { get }
}
