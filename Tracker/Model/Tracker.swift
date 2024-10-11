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

enum WeekDays: Int {
    case Monday = 1
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}

enum TrackerSchedule {
    case daily
    case weekly([WeekDays])
    case specificDates([Date])
}

struct Tracker {
    let id: UUID
    let name: String
    let color: TrackerColor
    let emoji: Emoji
    let schedule: TrackerSchedule
}
