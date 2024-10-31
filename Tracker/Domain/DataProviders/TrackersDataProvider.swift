//
//  TrackersDataProvider.swift
//  Tracker
//
//  Created by Alexander Bralnin on 31.10.2024.
//

import Foundation
import CoreData

struct TrackersStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

protocol DataProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackersStoreUpdate)
    func reloadData()
}

protocol TrackerDataProviderProtocol {
    var currentDate: Date { get set }
    func numberOfSections() -> Int
    func titleForSection(_ section: Int) -> String?
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at: IndexPath) -> Tracker?
    func addRecord(_ record: Tracker) throws
    func deleteRecord(at indexPath: IndexPath) throws
    func addTestCategory()
}

final class TrackersDataProvider: NSObject {
    var currentDate: Date = Date() {
        didSet {
            updateFetchRequest()
        }
    }
    private let delegate: DataProviderDelegate?
    private let context: NSManagedObjectContext
    private let dataStore: TrackerStore
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
        
    private func updateFetchRequest() {
        let fetchRequest = fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "date == %@", currentDate.startOfDay() as NSDate)
        
        do {
            try fetchedResultsController.performFetch()
            delegate?.reloadData()
        } catch {
            print("Failed to fetch filtered results: \(error)")
        }
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tracker_category.title", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "date == %@", currentDate.startOfDay() as NSDate)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: "tracker_category.title",
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    
    init(delegate: DataProviderDelegate) throws {
        self.delegate = delegate
        self.dataStore = TrackerStore()
        self.context = dataStore.managedObjectContext
    }
    
}

extension TrackersDataProvider: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath {
                insertedIndexes?.insert(newIndexPath.item)
            }
        case .delete:
            if let newIndexPath {
                deletedIndexes?.insert(newIndexPath.item)
            }
        case .update:
            print("Unsupported")
        case .move:
            print("Unsupported")
        @unknown default:
            fatalError("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let insertedIndexes,
            let deletedIndexes
        else {return}
        
        let update = TrackersStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes
        )
        
        delegate?.didUpdate(update)
        
        self.insertedIndexes = nil
        self.deletedIndexes = nil
    }
    
}


extension TrackersDataProvider: TrackerDataProviderProtocol {
    
    func numberOfSections() -> Int {
        let num = fetchedResultsController.sections?.count ?? 0
        print(num)
        return num
    }
    
    func titleForSection(_ section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else { return nil }
        return sections[section].name
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let record = fetchedResultsController.object(at: indexPath)
        return try? dataStore.getTracker(from: record)
    }
    
    func addRecord(_ record: Tracker) throws {
        dataStore.addTracker(what: record, for: "Базовая")
    }
    
    func deleteRecord(at indexPath: IndexPath) throws {
        //TODO: - implement
        print("Unsupported operation")
    }
    
    func addTestCategory()  {
        //TODO: - remove
        if fetchedResultsController.sections?.count ?? 0 == 0 {
            do {
                let categoryStore = TrackerCategoryStore()
                let category = TrackerCategory(title: "Базовая")
                try categoryStore.addTrackerCategory(category)
            } catch {
                print(error)
            }
        }
    }
    
}
