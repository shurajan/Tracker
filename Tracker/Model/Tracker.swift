//
//  Tracker.swift
//  Tracker
//
//  Created by Alexander Bralnin on 09.10.2024.
//

import UIKit

enum TrackerSchedule {
    case weekly([WeekDays])
    case specificDate(Date)
}

struct Tracker: Equatable {
    let id: UUID
    let name: String
    let color: TrackerColor
    let emoji: Emoji
    let schedule: TrackerSchedule
    
    static func == (lhs: Tracker, rhs: Tracker) -> Bool {
        return lhs.id == rhs.id
    }
}
