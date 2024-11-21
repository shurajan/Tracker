//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.11.2024.
//
import Foundation

protocol TrackersViewModelProtocol: AnyObject {
    var trackersBinding: Binding<[TrackerCategory]>? { get set }
    var visibleCategories: [TrackerCategory] { get }
    func addTracker(tracker: Tracker, category: String)
    func updateTracker(tracker: Tracker, newCategory: String?)
    func deleteTracker(for id: UUID)
    func togglePinned(for id: UUID)
    func fetchTrackers(for date: Date)
    func filter(predicates: [ (Tracker) -> Bool ])
    func category(for id: UUID) -> String?
    func hasData() -> Bool
}

final class TrackersViewModel: TrackersViewModelProtocol {
    var trackersBinding: Binding<[TrackerCategory]>?
    
    private let trackerStore = TrackerStore()
    private var categories: [TrackerCategory] = []
    
    private(set) var visibleCategories: [TrackerCategory] = [] {
        didSet {
            trackersBinding?(visibleCategories)
        }
    }
    
    private var currentDate: Date?
    private var currentPredicates: [ (Tracker) -> Bool ] = []
    
    init() {
        trackerStore.delegate = self
    }
    
    func addTracker(tracker: Tracker, category: String) {
        trackerStore.addTracker(tracker: tracker, category: category)
    }
    
    func updateTracker(tracker: Tracker, newCategory: String?) {
        trackerStore.updateTracker(with: tracker, newCategory: newCategory)
    }
    
    func deleteTracker(for id: UUID) {
        trackerStore.deleteTracker(by: id)
    }
    
    func togglePinned(for id: UUID) {
        trackerStore.togglePinned(for: id)
    }
    
    func fetchTrackers(for date: Date) {
        self.currentDate = date
        categories = trackerStore.fetchTrackers(for: date)
        
        if !currentPredicates.isEmpty {
            filter(predicates: currentPredicates)
        } else {
            visibleCategories = categories
        }
    }
    
    func filter(predicates: [ (Tracker) -> Bool ]) {
        self.currentPredicates = predicates
        visibleCategories = []
        
        for category in categories {
            let filteredTrackers = category.trackers?.filter { tracker in
                for predicate in predicates {
                    if !predicate(tracker) {
                        return false
                    }
                }
                return true
            }
            
            if let filteredTrackers = filteredTrackers, !filteredTrackers.isEmpty {
                visibleCategories.append(TrackerCategory(title: category.title, trackers: filteredTrackers))
            }
        }
        
        trackersBinding?(visibleCategories)
    }
    
    func category(for id: UUID) -> String? {
        return trackerStore.getTrackerCategoryTitle(by: id)
    }
    
    func hasData() -> Bool {
        return !categories.isEmpty
    }
}

extension TrackersViewModel: StoreDelegate {
    func storeDidUpdate() {
        if let currentDate = self.currentDate {
            fetchTrackers(for: currentDate)
        }
    }
}
