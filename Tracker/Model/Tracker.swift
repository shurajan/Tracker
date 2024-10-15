//
//  Tracker.swift
//  Tracker
//
//  Created by Alexander Bralnin on 09.10.2024.
//

import UIKit

enum TrackerColor: String, CaseIterable {
    case selection1 = "#FD4C49"   // Color selection 1
    case selection2 = "#FF881E"   // Color selection 2
    case selection3 = "#007BFA"   // Color selection 3
    case selection4 = "#6E44FE"   // Color selection 4
    case selection5 = "#33CF69"   // Color selection 5
    case selection6 = "#E66DD4"   // Color selection 6
    case selection7 = "#F9D4D4"   // Color selection 7
    case selection8 = "#34A7FE"   // Color selection 8
    case selection9 = "#46E69D"   // Color selection 9
    case selection10 = "#35347C"  // Color selection 10
    case selection11 = "#FF674D"  // Color selection 11
    case selection12 = "#FF99CC"  // Color selection 12
    case selection14 = "#7994F5"  // Color selection 14
    case selection15 = "#832CF1"  // Color selection 15
    case selection16 = "#AD56DA"  // Color selection 16
    case selection17 = "#8D72E6"  // Color selection 17
    case selection18 = "#2FD058"  // Color selection 18
    
    var uiColor: UIColor {
        return UIColor(hex: self.rawValue)
    }
}

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


enum TrackerSchedule {
    case weekly([WeekDays])
    case specificDate(Date)
}

struct Tracker {
    let id: UUID
    let name: String
    let color: TrackerColor
    let emoji: Emoji
    let schedule: TrackerSchedule
}
