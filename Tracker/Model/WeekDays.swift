//
//  WeekDays.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.10.2024.
//
import UIKit

enum WeekDays: Int, CaseIterable, Comparable {
    case Понедельник = 1
    case Вторник
    case Среда
    case Четверг
    case Пятница
    case Суббота
    case Воскресенье
    
    static func < (lhs: WeekDays, rhs: WeekDays) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    // Возвращает количество дней в неделе
    static var count: Int {
        return WeekDays.Воскресенье.rawValue
    }
    
    // Преобразование Int в WeekDays (безопасно)
    static func from(_ intValue: Int) -> WeekDays? {
        return WeekDays(rawValue: intValue)
    }
    
    static func fromGregorianStyle(_ intValue: Int) -> WeekDays? {
        if intValue == 1 {
            return .from(7)
        }
        return .from(intValue-1)
    }
    
    // Преобразование WeekDays в строку
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
        }
    }
    
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
        }
    }
}
