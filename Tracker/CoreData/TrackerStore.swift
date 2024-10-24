//
//  TrackerStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//

import CoreData

final class TrackerStore: BasicStore {
    
    func addTrackerCategory(_ tracker : Tracker) {
        let trackerCoreDate = TrackerCoreData(context: self.managedObjectContext)
        trackerCoreDate.id = tracker.id
        trackerCoreDate.name = tracker.name
        trackerCoreDate.colorHex = tracker.color.rawValue
        trackerCoreDate.emoji = tracker.emoji.rawValue
        trackerCoreDate.date = tracker.date
        trackerCoreDate.schedule = tracker.schedule?.rawValue
    }
}
