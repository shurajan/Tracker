//
//  FilterPredicateFactory.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.11.2024.
//

import Foundation

enum Filters: String, CaseIterable {
    case allTrackers = "filters.all_trackers"
    case todayTrackers = "filters.today_trackers"
    case completed = "filters.completed"
    case notCompleted = "filters.not_completed"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

final class FilterPredicateFactory {
    
    static func makePredicate(for filter: Filters, date: Date) -> NSPredicate {
        switch filter {
        case .allTrackers:
            return allTrackers()
            
        case .todayTrackers:
            return trackersForDate(date: date)
            
        case .completed:
            return completed(date: date)
            
        case .notCompleted:
            return notCompleted(date: date)
        }
    }
    
    private static func allTrackers() -> NSPredicate {
        return NSPredicate(value: true)
    }
    
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
    
    private static func completed(date: Date) -> NSPredicate {
        let dateStart = date.startOfDay() as NSDate
        return NSPredicate(format: "ANY tracker_records.date == %@", dateStart)
    }
    
    private static func notCompleted(date: Date) -> NSPredicate {
        let dateStart = date.startOfDay() as NSDate
        return NSPredicate(format: "NONE tracker_records.date == %@", dateStart)
    }
    
}
