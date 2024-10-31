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
    
    func addTrackerCategory(_ trackerCategory :TrackerCategory) throws {
        do {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: self.managedObjectContext)
            trackerCategoryCoreData.title = trackerCategory.title
            try save()
        } catch{
            print(error)
            throw TrackerCategoryStoreError.createCategoryError
        }
    }
    
    func getTrackerCategoryCoreData(by title: String) -> TrackerCategoryCoreData? {
        let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        if let fetchedCategory = try? managedObjectContext.fetch(categoryFetchRequest).first {
            return fetchedCategory
        }
        return nil
        
    }
    
    func getTrackerCategory(by title: String) -> TrackerCategory? {
        
        if let categoryCoreData = getTrackerCategoryCoreData(by: title){
            return TrackerCategory(title: categoryCoreData.title ?? "")
        }
        
        return nil
    }
    
}
