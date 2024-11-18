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
        trackerCoreData.isPinned = tracker.isPinned
        
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
        
        let isPinned = trackerCoreData.isPinned
        return Tracker(id: id,
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

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate()
    }
}
