//
//  WeekDays.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.10.2024.
//
import UIKit

struct WeekDays: OptionSet {
    let rawValue: Int
    
    static let Понедельник = WeekDays(rawValue: 1 << 0)
    static let Вторник = WeekDays(rawValue: 1 << 1)
    static let Среда = WeekDays(rawValue: 1 << 2)
    static let Четверг = WeekDays(rawValue: 1 << 3)
    static let Пятница = WeekDays(rawValue: 1 << 4)
    static let Суббота = WeekDays(rawValue: 1 << 5)
    static let Воскресенье = WeekDays(rawValue: 1 << 6)
    
    // Все дни недели
    static let Daily: WeekDays = [.Понедельник, .Вторник, .Среда, .Четверг, .Пятница, .Суббота, .Воскресенье]
    
    static var count: Int {
        return 7
    }

    static func from(_ intValue: Int) -> WeekDays? {
        guard intValue >= 0 && intValue < count else { return nil }
        return WeekDays(rawValue: 1 << intValue)
    }
    
    static func fromGregorianStyle(_ intValue: Int) -> WeekDays? {
        guard intValue >= 1 && intValue <= 7 else { return nil }
        return intValue == 1 ? .Воскресенье : WeekDays(rawValue: 1 << (intValue - 2))
    }
    
    var description: String {
        switch self {
        case .Понедельник:
            return "Понедельник"
        case .Вторник:
            return "Вторник"
        case .Среда:
            return "Среда"
        case .Четверг:
            return "Четверг"
        case .Пятница:
            return "Пятница"
        case .Суббота:
            return "Суббота"
        case .Воскресенье:
            return "Воскресенье"
        default:
            return "Неизвестный день"
        }
    }
    
    // Краткое описание дня недели
    var shortDescription: String {
        switch self {
        case .Понедельник:
            return "Пн"
        case .Вторник:
            return "Вт"
        case .Среда:
            return "Ср"
        case .Четверг:
            return "Чт"
        case .Пятница:
            return "Пт"
        case .Суббота:
            return "Сб"
        case .Воскресенье:
            return "Вс"
        default:
            return "?"
        }
    }
}

extension WeekDays: Sequence {
    public func makeIterator() -> AnyIterator<WeekDays> {
        var currentBit = 1
        return AnyIterator {
            while currentBit < (1 << 7) {
                let day = WeekDays(rawValue: currentBit)
                currentBit <<= 1
                if self.contains(day) {
                    return day
                }
            }
            return nil
        }
    }
}
