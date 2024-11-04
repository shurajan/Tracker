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
    var onDataUpdate: ((_ update: IndexUpdate)->Void)?
    
    private(set) var currentDate: Date = Date()
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tracker_category.title", ascending: false)]
        fetchRequest.predicate = setupPredicate(date: currentDate)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: managedObjectContext,
                                                                  sectionNameKeyPath: "tracker_category.title",
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    private var insertedSections = IndexSet()
    private var deletedSections = IndexSet()
    private var insertedItems = [Int: IndexSet]()
    private var deletedItems = [Int: IndexSet]()
    private var updatedItems = [Int: IndexSet]()
    private var movedItems = [(from: IndexPath, to: IndexPath)]()
            
    //MARK: - Private Functions
    private func setupPredicate(date: Date) -> NSPredicate {
        let calendar = Calendar.current
        let currentWeekdayInt = calendar.component(.weekday, from: date)
        let currentWeekday = WeekDays.fromGregorianStyle(currentWeekdayInt)?.rawValue ?? 0
        let dateStart = date.startOfDay() as NSDate
        
        let datePredicate = NSPredicate(format: "date == %@", dateStart)
        let scheduleZeroPredicate = NSPredicate(format: "schedule == 0 OR schedule == nil")
        let dateAndNoSchedulePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, scheduleZeroPredicate])
        
        let scheduleContainsDayPredicate = NSPredicate(format: "(schedule & %d) != 0", currentWeekday)
        
        let finalPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [dateAndNoSchedulePredicate, scheduleContainsDayPredicate])
        
        return finalPredicate
    }
    
    
    private func updateFetchRequest() {
        let fetchRequest = fetchedResultsController.fetchRequest
        fetchRequest.predicate = setupPredicate(date: currentDate)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Log.error(error: error, message: "Failed to fetch filtered results")
        }
    }
    
    private func from(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
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
    
    private func findCoreData(by id: UUID) throws -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let fetchedTracker = try? managedObjectContext.fetch(fetchRequest).first {
            return fetchedTracker
        }
        return nil
    }
    
    private func findTrackerCategory(by title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        if let fetchedCategory = try? managedObjectContext.fetch(fetchRequest).first {
            return fetchedCategory
        }
        return nil
        
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
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
        
        if let onDataUpdate = onDataUpdate {
            onDataUpdate(update)
        }
        
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

extension TrackerStore: TrackersViewModelProtocol {
    func setCurrentDate(new date: Date, completion:()->Void) {
        self.currentDate = date
        updateFetchRequest()
        completion()
    }
    
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
            let trackerCategoryCoreData = findTrackerCategory(by: category.title)
            trackerCoreData.tracker_category = trackerCategoryCoreData
        } catch {
            Log.error(error: error, message: "failed to save tracker")
        }
        
        do {
            try save()
        } catch {
            Log.error(error: error, message: "failed to save tracker in storage")
        }
    }
    
    func findTracker(at indexPath: IndexPath) -> Tracker? {
        let record = fetchedResultsController.object(at: indexPath)
        return try? from(record)
    }
    
    func hasItems() -> Bool {
        let sections = self.fetchedResultsController.sections ?? []
        return sections.contains { $0.numberOfObjects > 0 }
    }
    
    func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func titleForSection(_ section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else { return nil }
        return sections[section].name
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
}
