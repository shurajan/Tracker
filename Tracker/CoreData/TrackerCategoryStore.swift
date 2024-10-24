//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//

import CoreData

final class TrackerCategoryStore: BasicStore {
    
    func addTrackerCategory(_ trackerCategory :TrackerCategory) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: self.managedObjectContext)
        trackerCategoryCoreData.id = trackerCategory.id
        trackerCategoryCoreData.title = trackerCategory.title
    }
}
