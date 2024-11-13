//
//  Constants.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.10.2024.
//

import UIKit

enum Constants {
    static let radius = CGFloat(16)
    static let smallRadius = CGFloat(8)
    static let trackerNameMaxLength = 38
}

enum Insets {
    static let leading = CGFloat(16)
    static let trailing = CGFloat(-16)
    static let top = CGFloat(24)
    static let bottom = CGFloat(-24)
    static let cellInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    static let separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
}

enum Fonts {
    static let titleMediumFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let titleLargeFont = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let labelFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let textFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let sectionHeaderFont = UIFont.systemFont(ofSize: 19, weight: .bold)
    static let emojiFont = UIFont.systemFont(ofSize: 32)
}
