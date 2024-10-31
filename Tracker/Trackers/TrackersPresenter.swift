//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Alexander Bralnin on 31.10.2024.
//

import Foundation

protocol TrackersPresenterProtocol {
    var currentDate: Date { get set }
    
    func addNewCategory(_ category: TrackerCategory)
    func addNewTracker(_ tracker: Tracker)
    func addNewTrackerRecord(tracker: Tracker) -> Int
    func isDone(trackerID: UUID) -> Bool
    func countCompletions (trackerID: UUID) -> Int
    func loadTrackers()
}

final class TrackersPresenter: TrackersPresenterProtocol {

    
    weak var view: TrackersViewProtocol?
    var currentDate: Date = Date()
    
    private var categories: [TrackerCategory] = []
    private var filteredTrackers: [Tracker] = []
    private var completedTrackers: [TrackerRecord] = []
    private var completedTrackersSet: Set<TrackerRecord> = []
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
    
    func addNewCategory(_ category: TrackerCategory) {
        self.categories = categories + [category]
        view?.showCategories(categories)
    }
    
    func addNewTracker(_ tracker: Tracker) {
        guard let category = categories[safe: 0] else {return}
        let trackers = category.trackers + [tracker]
        categories.remove(at: 0)
        categories.append(TrackerCategory(id: category.id, title: category.title, trackers: trackers))
        loadTrackers()
    }
        
    func addNewTrackerRecord(tracker: Tracker) -> Int {
        let record = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        let isSetContainingID = completedTrackersSet.contains(record)
        
        if !isSetContainingID {
            completedTrackers.append(record)
            completedTrackersSet.insert(record)
            
            if tracker.schedule == nil {
                return 1
            }
            
            return completedTrackers.filter { $0.trackerId == tracker.id }.count
        }
        
        let index = completedTrackers.firstIndex(where: {$0 == record})
        
        if let index {
            completedTrackers.remove(at: index)
            completedTrackersSet.remove(record)
            let count = completedTrackers.filter { $0.trackerId == tracker.id }.count
            return count
        }
        
        return 0
    }
    
    func isDone(trackerID: UUID) -> Bool {
        let record = TrackerRecord(trackerId: trackerID, date: currentDate)
        return completedTrackersSet.contains(record)
    }
    
    func countCompletions (trackerID: UUID) -> Int {
        return completedTrackers.filter { $0.trackerId == trackerID }.count
    }
    
    func IsDone(trackerID: UUID) -> Bool {
        let record = TrackerRecord(trackerId: trackerID, date: currentDate)
        return completedTrackersSet.contains(record)
    }
    
    func loadTrackers() {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: currentDate)
        
        filteredTrackers = categories.flatMap { $0.trackers }.filter { tracker in
            if let schedule = tracker.schedule,
               let weekDay = WeekDays.fromGregorianStyle(dayOfWeek) {
                return schedule.contains(weekDay)
            }
            return calendar.isDate(tracker.date, inSameDayAs: currentDate)
        }
        view?.showTrackers(filteredTrackers)
    }
    
}
