//
//  BasicStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//
import CoreData
import UIKit

class BasicStore: NSObject {
    private let context: NSManagedObjectContext
    
    override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось получить AppDelegate")
        }
        
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func deleteAll() {
        let trackerFetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerCoreData.fetchRequest()
        let trackerCategoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerCategoryCoreData.fetchRequest()
        let trackerRecordFetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
        
        let deleteTrackerRequest = NSBatchDeleteRequest(fetchRequest: trackerFetchRequest)
        let deleteCategoryRequest = NSBatchDeleteRequest(fetchRequest: trackerCategoryFetchRequest)
        let deleteRecordRequest = NSBatchDeleteRequest(fetchRequest: trackerRecordFetchRequest)
        
        do {
            try context.execute(deleteTrackerRequest)
            try context.execute(deleteCategoryRequest)
            try context.execute(deleteRecordRequest)
            try save()
        } catch {
            Log.error(error: error, message: "Failed to delete all data from Core Data")
        }
    }
    
    func save() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    }
}

extension BasicStore {
    var managedObjectContext: NSManagedObjectContext {
        return context
    }
}
