//
//  WeekDays.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.10.2024.
//
import UIKit

struct WeekDays: OptionSet {
    let rawValue: Int32
    
    static let Monday = WeekDays(rawValue: 1 << 0)
    static let Tuesday = WeekDays(rawValue: 1 << 1)
    static let Wednesday = WeekDays(rawValue: 1 << 2)
    static let Thursday = WeekDays(rawValue: 1 << 3)
    static let Friday = WeekDays(rawValue: 1 << 4)
    static let Saturday = WeekDays(rawValue: 1 << 5)
    static let Sunday = WeekDays(rawValue: 1 << 6)
    
    static let Daily: WeekDays = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
    
    static var count: Int {
        return 7
    }
    
    static func from(_ intValue: Int32) -> WeekDays? {
        guard intValue >= 0 && intValue < count else { return nil }
        return WeekDays(rawValue: 1 << intValue)
    }
    
    static func fromGregorianStyle(_ intValue: Int) -> WeekDays? {
        guard intValue >= 1 && intValue <= 7 else { return nil }
        return intValue == 1 ? .Sunday : WeekDays(rawValue: 1 << (intValue - 2))
    }
    
    var description: String {
        switch self {
        case .Monday:
            return LocalizedStrings.WeekDays.monday
        case .Tuesday:
            return LocalizedStrings.WeekDays.tuesday
        case .Wednesday:
            return LocalizedStrings.WeekDays.wednesday
        case .Thursday:
            return LocalizedStrings.WeekDays.thursday
        case .Friday:
            return LocalizedStrings.WeekDays.friday
        case .Saturday:
            return LocalizedStrings.WeekDays.saturday
        case .Sunday:
            return LocalizedStrings.WeekDays.sunday
        case .Daily:
            return LocalizedStrings.WeekDays.allDays
        default:
            return "Unknown Day"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .Monday:
            return LocalizedStrings.WeekDays.shortMonday
        case .Tuesday:
            return LocalizedStrings.WeekDays.shortTuesday
        case .Wednesday:
            return LocalizedStrings.WeekDays.shortWednesday
        case .Thursday:
            return LocalizedStrings.WeekDays.shortThursday
        case .Friday:
            return LocalizedStrings.WeekDays.shortFriday
        case .Saturday:
            return LocalizedStrings.WeekDays.shortSaturday
        case .Sunday:
            return LocalizedStrings.WeekDays.shortSunday
        case .Daily:
            return LocalizedStrings.WeekDays.allDays
        default:
            return "?"
        }
    }
}

extension WeekDays: Sequence {
    public func makeIterator() -> AnyIterator<WeekDays> {
        var currentBit: Int32 = 1
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
