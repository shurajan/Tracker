//
//  FilterPredicateFactory.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.11.2024.
//

import Foundation

enum PredicateType {
    case all
    case date(Date)
    case isPinned(Bool)
}

final class FilterPredicateFactory {
    
    static func makePredicate(for type: PredicateType) -> NSPredicate {
        switch type {
        case .all:
            return NSPredicate(value: true)
        case .date(let date):
            return trackersForDate(date: date)
        case .isPinned(let pinned):
            return NSPredicate(format: "isPinned == %@", NSNumber(value: pinned))
        }
    }
    
    // MARK: - Private Helper Methods
    private static func trackersForDate(date: Date) -> NSPredicate {
        let calendar = Calendar.current
        let currentWeekdayInt = calendar.component(.weekday, from: date)
        let currentWeekday = WeekDays.fromGregorianStyle(currentWeekdayInt)?.rawValue ?? 0
        let dateStart = date.startOfDay() as NSDate
        
        let datePredicate = NSPredicate(format: "date == %@", dateStart)
        let scheduleZeroPredicate = NSPredicate(format: "schedule == 0 OR schedule == nil")
        
        let dateAndNoSchedulePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, scheduleZeroPredicate])
        let scheduleContainsDayPredicate = NSPredicate(format: "(schedule & %d) != 0", currentWeekday)
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: [dateAndNoSchedulePredicate, scheduleContainsDayPredicate])
    }
}
