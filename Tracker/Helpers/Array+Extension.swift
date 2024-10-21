//
//  Array+Extension.swift
//  Tracker
//
//  Created by Alexander Bralnin on 15.10.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
