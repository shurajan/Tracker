//
//  BasicStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//
import CoreData
import UIKit

class BasicStore {
    private let context: NSManagedObjectContext
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось получить AppDelegate")
        }
        
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
