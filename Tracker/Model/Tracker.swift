//
//  Tracker.swift
//  Tracker
//
//  Created by Alexander Bralnin on 09.10.2024.
//

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
    let color: UIColor
    let emoji: Emoji
    let schedule: TrackerSchedule
}
