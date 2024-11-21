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
    func fetchTrackers(for date: Date, filters: [Filters] = []) -> [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        
        if let pinnedController = createPinnedFetchedResultsController(date: date, filters: filters) {
            self.pinnedFetchedResultsController = pinnedController
            if let pinnedObjects = pinnedController.fetchedObjects {
                let pinnedTrackers: [Tracker] = pinnedObjects.compactMap { try? from($0) }
                if !pinnedTrackers.isEmpty {
                    let pinnedCategory = TrackerCategory(title: LocalizedStrings.Trackers.pinnedCategoryText, trackers: pinnedTrackers)
                    trackerCategories.append(pinnedCategory)
                }
            }
        }
        
        if let dateController = createDateFetchedResultsController(date: date, filters: filters) {
            self.dateFetchedResultsController = dateController
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
            Log.error(error: error, message: "failed to save tracker category")
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
            Log.error(error: error, message: "failed to toggle pinned state for tracker with id \(trackerID)")
        }
    }
    
    func getTrackerCategoryTitle(by id: UUID) -> String? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let trackerCoreData = try managedObjectContext.fetch(fetchRequest).first {
                return trackerCoreData.tracker_category?.title
            } else {
                Log.warn(message: "tracker with id \(id) not found")
            }
        } catch {
            Log.error(error: error, message: "failed to get category for tracker with id \(id)")
        }
        
        return nil
    }
    
    // MARK: - Private Functions
    private func createPinnedFetchedResultsController(date: Date, filters: [Filters] = []) -> NSFetchedResultsController<TrackerCoreData>? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        fetchRequest.predicate = setupPinnedPredicate(date: date, filters: filters)
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController
        } catch {
            Log.error(error: error, message: "Failed to perform fetch for pinned trackers")
            return nil
        }
    }
    
    private func setupPinnedPredicate(date: Date, filters: [Filters] = []) -> NSPredicate {
        let builder = FilterPredicateBuilder()
            .and(NSPredicate(format: "isPinned == true"))
        
        for filter in filters {
            builder.and(filter, date: date)
        }
        
        return builder.build()
    }
    
    private func createDateFetchedResultsController(date: Date, filters: [Filters] = []) -> NSFetchedResultsController<TrackerCoreData>? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "tracker_category.title", ascending: true),
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        fetchRequest.predicate = setupDatePredicate(date: date, filters: filters)
        
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
            Log.error(error: error, message: "Failed to perform fetch for date-based trackers")
            return nil
        }
    }
    
    private func setupDatePredicate(date: Date, filters: [Filters] = []) -> NSPredicate {
        let builder = FilterPredicateBuilder()
            .and(.todayTrackers, date: date)
            .and(NSPredicate(format: "isPinned == false"))
        
        for filter in filters {
            builder.and(filter, date: date)
        }
        
        return builder.build()
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
