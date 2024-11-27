//
//  Tracker.swift
//  Tracker
//
//  Created by Alexander Bralnin on 09.10.2024.
//

import UIKit

struct Tracker: Equatable {
    let id: UUID
    let name: String
    let color: TrackerColor
    let emoji: Emoji
    let date: Date
    let schedule: WeekDays?
    let isPinned: Bool
    let isComplete: Bool
    
    init(id: UUID, name: String, color: TrackerColor, emoji: Emoji, date: Date, schedule: WeekDays?, isPinned: Bool, isComplete: Bool = false) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.date = date
        self.schedule = schedule
        self.isPinned = isPinned
        self.isComplete = isComplete
    }
    
    static func == (lhs: Tracker, rhs: Tracker) -> Bool {
        return lhs.id == rhs.id
    }
}
