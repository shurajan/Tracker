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
    
    func addTracker(tracker : Tracker, category : TrackerCategory) {
        
        let trackerCoreData = TrackerCoreData(context: self.managedObjectContext)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.colorHex = tracker.color.rawValue
        trackerCoreData.emoji = tracker.emoji.rawValue
        trackerCoreData.date = tracker.date.startOfDay()
        if let schedule = tracker.schedule?.rawValue{
            trackerCoreData.schedule = schedule
        }
        
        do{
            try trackerCategoryStore.addTrackerCategory(category: category)
            let trackerCategoryCoreData = trackerCategoryStore.findCoreData(by: category.title)
            trackerCoreData.tracker_category = trackerCategoryCoreData
        } catch {
            Log.error(error: error, message: "failed to save tracker")
        }
    }
    
    func from(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
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
    
    func findCoreData(by id: UUID) throws -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let fetchedTracker = try? managedObjectContext.fetch(fetchRequest).first {
            return fetchedTracker
        }
        return nil
    }
}
