//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//

import CoreData

enum TrackerCategoryStoreError: Error {
    case createCategoryError
}

final class TrackerCategoryStore: BasicStore {
    
    func addTrackerCategory(category : String) throws {
        if find(by: category) != nil {
            return
        }
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: self.managedObjectContext)
        trackerCategoryCoreData.title = category
    }
        
    private func find(by title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        if let fetchedCategory = try? managedObjectContext.fetch(fetchRequest).first {
            return fetchedCategory
        }
        return nil
        
    }
        
}
