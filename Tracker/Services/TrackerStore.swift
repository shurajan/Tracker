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
    var delegate: StoreDelegate?
    
    private var trackerCategoryStore = TrackerCategoryStore()
    private var trackerRecordStore = TrackerRecordStore()
    private var pinnedFetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    private var dateFetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    // MARK: - Public Functions
    
    func fetchTrackers(for date: Date) -> [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        
        pinnedFetchedResultsController = createFetchedResultsController(isPinned: true)
        
        if let pinnedController = pinnedFetchedResultsController {
            if let pinnedSections = pinnedController.sections {
                var pinnedTrackers: [Tracker] = []
                
                for section in pinnedSections {
                    guard let objects = section.objects as? [TrackerCoreData] else { continue }
                    let trackers: [Tracker] = objects.compactMap { try? from($0) }
                    if !trackers.isEmpty {
                        pinnedTrackers.append(contentsOf: trackers)
                    }
                }
                
                if !pinnedTrackers.isEmpty {
                    let pinnedCategory = TrackerCategory(title: "Pinned", trackers: pinnedTrackers)
                    trackerCategories.append(pinnedCategory)
                }
            }
        }
        
        dateFetchedResultsController = createFetchedResultsController(date: date.startOfDay(), isPinned: false)
        
        if let dateController = dateFetchedResultsController {
            if let sections = dateController.sections {
                for section in sections {
                    guard let objects = section.objects as? [TrackerCoreData] else { continue }
                    let trackers: [Tracker] = objects.compactMap { try? from($0) }
                    let trackerCategory = TrackerCategory(title: section.name, trackers: trackers)
                    trackerCategories.append(trackerCategory)
                }
            }
        }
        
        return trackerCategories
    }
    
    func addTracker(tracker: Tracker, category: String) {
        let trackerCoreData = TrackerCoreData(context: self.managedObjectContext)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.colorHex = tracker.color.rawValue
        trackerCoreData.emoji = tracker.emoji.rawValue
        trackerCoreData.date = tracker.date.startOfDay()
        trackerCoreData.creationDate = Date()
        if let schedule = tracker.schedule?.rawValue {
            trackerCoreData.schedule = schedule
        }
        trackerCoreData.isPinned = tracker.isPinned
        
        do {
            try trackerCategoryStore.addTrackerCategory(category: category)
            trackerCoreData.tracker_category = findTrackerCategory(by: category)
        } catch {
            Log.error(error: error, message: "failed to save tracker")
        }
        
        do {
            try save()
        } catch {
            Log.error(error: error, message: "failed to save tracker in storage")
        }
    }
    
    func updateTracker(with updatedTracker: Tracker, newCategory: String? = nil) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", updatedTracker.id as CVarArg)
        
        do {
            if let trackerCoreData = try managedObjectContext.fetch(fetchRequest).first {
                trackerCoreData.name = updatedTracker.name
                trackerCoreData.colorHex = updatedTracker.color.rawValue
                trackerCoreData.emoji = updatedTracker.emoji.rawValue
                trackerCoreData.date = updatedTracker.date.startOfDay()
                trackerCoreData.isPinned = updatedTracker.isPinned
                
                if let schedule = updatedTracker.schedule?.rawValue {
                    trackerCoreData.schedule = schedule
                }
                
                if let newCategory = newCategory {
                    try trackerCategoryStore.addTrackerCategory(category: newCategory)
                    trackerCoreData.tracker_category = findTrackerCategory(by: newCategory)
                }
                
                try save()
            } else {
                Log.warn(message: "tracker with id \(updatedTracker.id) not found")
            }
        } catch {
            Log.error(error: error, message: "failed to update tracker with id \(updatedTracker.id)")
        }
    }
    
    func deleteTracker(by id: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let trackerCoreData = try managedObjectContext.fetch(fetchRequest).first {
                trackerRecordStore.deleteById(by: id)
                managedObjectContext.delete(trackerCoreData)
                try save()
            } else {
                Log.warn(message: "tracker with id \(id) not found")
            }
        } catch {
            Log.error(error: error, message: "failed to delete tracker with id \(id)")
        }
    }
    
    func togglePinned(for trackerID: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        
        do {
            if let trackerCoreData = try managedObjectContext.fetch(fetchRequest).first {
                trackerCoreData.isPinned.toggle()
                try save()
            } else {
                Log.warn(message: "tracker with id \(trackerID) not found")
            }
        } catch {
            Log.error(error: error, message: "failed to toggle isPinned for tracker with id \(trackerID)")
        }
    }
    
    func getTrackerCategoryTitle(by id: UUID)-> String? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let trackerCoreData = try managedObjectContext.fetch(fetchRequest).first {
                return trackerCoreData.tracker_category?.title
            } else {
                Log.warn(message: "tracker with id \(id) not found")
            }
        } catch {
            Log.error(error: error, message: "failed to delete tracker with id \(id)")
        }
        
        return nil
    }
    
    // MARK: - Private Functions
    private func createFetchedResultsController(date: Date? = nil, isPinned: Bool? = nil) -> NSFetchedResultsController<TrackerCoreData>? {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "tracker_category.title", ascending: false),
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        fetchRequest.predicate = setupPredicate(date: date, isPinned: isPinned)
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: "tracker_category.title",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController
        } catch {
            Log.error(error: error, message: "failed to perform fetch")
            return nil
        }
    }
    
    private func setupPredicate(date: Date? = nil, isPinned: Bool? = nil) -> NSPredicate {
        var subpredicates: [NSPredicate] = []
        
        if let date = date {
            let calendar = Calendar.current
            let currentWeekdayInt = calendar.component(.weekday, from: date)
            let currentWeekday = WeekDays.fromGregorianStyle(currentWeekdayInt)?.rawValue ?? 0
            let dateStart = date.startOfDay() as NSDate
            
            let datePredicate = NSPredicate(format: "date == %@", dateStart)
            let scheduleZeroPredicate = NSPredicate(format: "schedule == 0 OR schedule == nil")
            
            let dateAndNoSchedulePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, scheduleZeroPredicate])
            let scheduleContainsDayPredicate = NSPredicate(format: "(schedule & %d) != 0", currentWeekday)
            
            let orPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [dateAndNoSchedulePredicate, scheduleContainsDayPredicate])
            subpredicates.append(orPredicate)
        }
        
        if let isPinned = isPinned {
            let isPinnedPredicate = NSPredicate(format: "isPinned == %@", NSNumber(value: isPinned))
            subpredicates.append(isPinnedPredicate)
        }
        
        if subpredicates.count > 1 {
            return NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
        } else if let singlePredicate = subpredicates.first {
            return singlePredicate
        } else {
            return NSPredicate(value: true)
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
        
        let isPinned = trackerCoreData.isPinned
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            date: date,
            schedule: WeekDays(rawValue: trackerCoreData.schedule),
            isPinned: isPinned
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

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate()
    }
}
