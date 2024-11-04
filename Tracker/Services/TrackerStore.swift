//
//  TrackerStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//

import CoreData

struct IndexUpdate {
    let insertedSections: IndexSet
    let deletedSections: IndexSet
    let insertedItems: [Int: IndexSet]
    let deletedItems: [Int: IndexSet]
    let updatedItems: [Int: IndexSet]
    let movedItems: [(from: IndexPath, to: IndexPath)]
}

enum TrackerDecodingError: Error {
    case decodingErrorInvalidValue
}

final class TrackerStore: BasicStore {
    var onDataUpdate: ((_ update: IndexUpdate)->Void)?
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tracker_category.title", ascending: false),
                                        NSSortDescriptor(key: "creationDate", ascending: true)]
        
        fetchRequest.predicate = setupPredicate(date: Date().startOfDay())
        
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
            
    
    //MARK: - Public Functions
    func fetchTrackers(for date: Date) -> [TrackerCategory] {
        updateFetchRequest(date: date.startOfDay())
        
        guard let sections = fetchedResultsController.sections else { return [] }
        
        var trackerCategories: [TrackerCategory] = []
        
        for section in sections {
            guard let objects = section.objects as? [TrackerCoreData] else { continue }
            
            let trackers: [Tracker] = objects.compactMap { try? from($0) }
            let trackerCategory = TrackerCategory(title: section.name, trackers: trackers)
            trackerCategories.append(trackerCategory)
        }
        
        return trackerCategories
    }
    
    
    func addTracker(tracker : Tracker, category : String) {
        let trackerCoreData = TrackerCoreData(context: self.managedObjectContext)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.colorHex = tracker.color.rawValue
        trackerCoreData.emoji = tracker.emoji.rawValue
        trackerCoreData.date = tracker.date.startOfDay()
        trackerCoreData.creationDate = Date()
        if let schedule = tracker.schedule?.rawValue{
            trackerCoreData.schedule = schedule
        }
        
        do{
            try trackerCategoryStore.addTrackerCategory(category: category)
            let trackerCategoryCoreData = findTrackerCategory(by: category)
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
    
    
    private func updateFetchRequest(date: Date) {
        let fetchRequest = fetchedResultsController.fetchRequest
        fetchRequest.predicate = setupPredicate(date: date)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Log.error(error: error, message: "failed to fetch filtered results")
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
        
    private func findTrackerCategory(by title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        if let fetchedCategory = try? managedObjectContext.fetch(fetchRequest).first {
            return fetchedCategory
        }
        return nil
        
    }
    
}

//MARK: - NSFetchedResultsControllerDelegate
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
