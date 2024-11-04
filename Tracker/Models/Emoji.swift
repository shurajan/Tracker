//
//  Emoji.swift
//  Tracker
//
//  Created by Alexander Bralnin on 09.10.2024.
//

enum Emoji: String, CaseIterable {
    case smile = "🙂"
    case heartEyesCat = "😻"
    case flower = "🌺"
    case dog = "🐶"
    case heart = "❤️"
    case scream = "😱"
    case angel = "😇"
    case angry = "😡"
    case cold = "🥶"
    case thinking = "🤔"
    case handsUp = "🙌"
    case burger = "🍔"
    case broccoli = "🥦"
    case pingPong = "🏓"
    case goldMedal = "🥇"
    case guitar = "🎸"
    case island = "🏝"
    case sleepy = "😪"
    
    // Метод поиска по строковому представлению эмодзи или по имени case'а
    static func from(rawValue: String) -> Emoji? {
        // Поиск по значению эмодзи
        if let emoji = Emoji.allCases.first(where: { $0.rawValue == rawValue }) {
            return emoji
        }
        
        // Поиск по названию case'а
        if let emoji = Emoji.allCases.first(where: { String(describing: $0) == rawValue }) {
            return emoji
        }
        
        return nil
    }
    
    func emojiName() -> String {
        return String(describing: self)
    }
}
