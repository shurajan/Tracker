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
    
    func addTrackerCategory(category : TrackerCategory) throws {
        if let existingCategory = find(by: category.title) {
            return
        }
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: self.managedObjectContext)
        trackerCategoryCoreData.title = category.title
        
    }
        
    func find(by title: String) -> TrackerCategory? {
        
        if let categoryCoreData = findCoreData(by: title){
            return TrackerCategory(title: categoryCoreData.title ?? "")
        }
        
        return nil
    }
    
    private func findCoreData(by title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        if let fetchedCategory = try? managedObjectContext.fetch(fetchRequest).first {
            return fetchedCategory
        }
        return nil
        
    }
        
}
