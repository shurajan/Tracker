//
//  TrackersDataProvider.swift
//  Tracker
//
//  Created by Alexander Bralnin on 31.10.2024.
//

import Foundation
import CoreData

final class TrackersViewDataProvider: NSObject {
    var currentDate: Date = Date() {
        didSet {
            updateFetchRequest()
        }
    }
    private let delegate: DataProviderDelegate?
    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStore
    private let trackerRecordStore: TrackerRecordStore
    
    private var insertedSections = IndexSet()
    private var deletedSections = IndexSet()
    private var insertedItems = [Int: IndexSet]()
    private var deletedItems = [Int: IndexSet]()
    private var updatedItems = [Int: IndexSet]()
    private var movedItems = [(from: IndexPath, to: IndexPath)]()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tracker_category.title", ascending: false)]
        fetchRequest.predicate = setupPredicate(date: currentDate)
        
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
        self.trackerStore = TrackerStore()
        self.trackerRecordStore = TrackerRecordStore()
        self.context = trackerStore.managedObjectContext
    }
    
    private func setupPredicate(date: Date) -> NSPredicate {
        let calendar = Calendar.current
        let currentWeekdayInt = calendar.component(.weekday, from: date)
        let currentWeekday = WeekDays.fromGregorianStyle(currentWeekdayInt)?.rawValue ?? 0
        let dateStart = date.startOfDay() as NSDate
        
        let format = "date == %@ OR (schedule & %d != 0)"
        
        return NSPredicate(format: format,
                           dateStart,
                           currentWeekday)
    }
    
    private func updateFetchRequest() {
        let fetchRequest = fetchedResultsController.fetchRequest
        fetchRequest.predicate = setupPredicate(date: currentDate)
        
        do {
            try fetchedResultsController.performFetch()
            delegate?.reloadData()
            delegate?.updatePlaceholderVisibility(isHidden: hasItems())
        } catch {
            Log.error(error: error, message: "Failed to fetch filtered results")
        }
    }
    
    private func hasItems() -> Bool {
        let sections = self.fetchedResultsController.sections ?? []
        return sections.contains { $0.numberOfObjects > 0 }
    }
    
}

extension TrackersViewDataProvider: TrackersViewDataProviderProtocol {
    func numberOfSections() -> Int {
        delegate?.updatePlaceholderVisibility(isHidden: hasItems())
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func titleForSection(_ section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else { return nil }
        return sections[section].name
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        let record = fetchedResultsController.object(at: indexPath)
        return try? trackerStore.getTracker(from: record)
    }
    
    func addTracker(tracker: Tracker, category: TrackerCategory) throws {
        trackerStore.addTracker(tracker: tracker, category: category)
        try  trackerStore.save()
    }
    
    func deleteTracker(at indexPath: IndexPath) throws {
        //TODO: - implement
        Log.warn(message: "Unsupported operation")
    }
    
    func manageTrackerRecord(trackerRecord: TrackerRecord) throws {
        trackerRecordStore.manageTrackerRecord(trackerRecord: trackerRecord)
        try  trackerRecordStore.save()
    }
    
    func trackerRecordExist(trackerRecord: TrackerRecord)-> Bool {
        return trackerRecordStore.exist(trackerRecord: trackerRecord)
    }
    
    func countTrackerRecords(trackerRecord: TrackerRecord) throws -> Int {
        return trackerRecordStore.count(by: trackerRecord.trackerId)
    }
}

extension TrackersViewDataProvider: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reset()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        case .delete:
            deletedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                var indexSet = insertedItems[newIndexPath.section] ?? IndexSet()
                indexSet.insert(newIndexPath.item)
                insertedItems[newIndexPath.section] = indexSet
            }
        case .delete:
            if let indexPath = indexPath {
                var indexSet = deletedItems[indexPath.section] ?? IndexSet()
                indexSet.insert(indexPath.item)
                deletedItems[indexPath.section] = indexSet
            }
        case .update:
            if let indexPath = indexPath {
                var indexSet = updatedItems[indexPath.section] ?? IndexSet()
                indexSet.insert(indexPath.item)
                updatedItems[indexPath.section] = indexSet
            }
        case .move:
            if let fromIndexPath = indexPath, let toIndexPath = newIndexPath {
                movedItems.append((from: fromIndexPath, to: toIndexPath))
            }
        @unknown default:
            fatalError("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let update = IndexUpdate(
            insertedSections: insertedSections,
            deletedSections: deletedSections,
            insertedItems: insertedItems,
            deletedItems: deletedItems,
            updatedItems: updatedItems,
            movedItems: movedItems
        )
        
        delegate?.didUpdate(update)
        delegate?.updatePlaceholderVisibility(isHidden: hasItems())
        
        reset()
    }
    
    private func reset(){
        insertedSections.removeAll()
        deletedSections.removeAll()
        insertedItems.removeAll()
        deletedItems.removeAll()
        updatedItems.removeAll()
        movedItems.removeAll()
    }
}
