//
//  Emoji.swift
//  Tracker
//
//  Created by Alexander Bralnin on 09.10.2024.
//

enum Emoji: String, CaseIterable {
    case grape = "🍇"
    case melon = "🍈"
    case watermelon = "🍉"
    case orange = "🍊"
    case lemon = "🍋"
    case banana = "🍌"
    case pineapple = "🍍"
    case mango = "🥭"
    case redApple = "🍎"
    case greenApple = "🍏"
    case pear = "🍐"
    case cherry = "🍒"
    case strawberry = "🍓"
    case blueberry = "🫐"
    case kiwi = "🥝"
    case tomato = "🍅"
    case olive = "🫒"
    case coconut = "🥥"
    case avocado = "🥑"
    case eggplant = "🍆"
    case potato = "🥔"
    case carrot = "🥕"
    case corn = "🌽"
    case chili = "🌶️"
    case pepper = "🫑"
    case cucumber = "🥒"
    case lettuce = "🥬"
    case broccoli = "🥦"
    case garlic = "🧄"
    case onion = "🧅"
    case mushroom = "🍄"
    
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
