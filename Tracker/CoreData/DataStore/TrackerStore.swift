//
//  TrackerStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//

import CoreData

enum TrackerDecodingError: Error {
    case decodingErrorInvalidValue
}

final class TrackerStore: BasicStore {
    private var trackerCategoryStore = TrackerCategoryStore()
    
    func addTracker(what tracker : Tracker, for category : String) {
        
        let trackerCoreData = TrackerCoreData(context: self.managedObjectContext)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.colorHex = tracker.color.rawValue
        trackerCoreData.emoji = tracker.emoji.rawValue
        trackerCoreData.date = tracker.date.startOfDay()
        if let schedule = tracker.schedule?.rawValue{
            trackerCoreData.schedule = schedule
        }
        
        if let existingCategory = trackerCategoryStore.getTrackerCategoryCoreData(by: category) {
            trackerCoreData.tracker_category = existingCategory
        } else {
            let newCategory = TrackerCategory(title: category)
            try? trackerCategoryStore.addTrackerCategory(newCategory)
            let existingCategory = trackerCategoryStore.getTrackerCategoryCoreData(by: category)
            trackerCoreData.tracker_category = existingCategory
        }
        
        try? save()
    }
    
    func getTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
           let name = trackerCoreData.name,
           let colorHex = trackerCoreData.colorHex,
           let color = TrackerColor(rawValue: colorHex),
           let emojiString = trackerCoreData.emoji,
           let emoji = Emoji(rawValue: emojiString),
              let date = trackerCoreData.date
        else {
            throw TrackerDecodingError.decodingErrorInvalidValue
        }
        
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       date: date,
                       schedule: WeekDays(rawValue: trackerCoreData.schedule)
        )
    }
}
