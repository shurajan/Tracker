//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.11.2024.
//
import Foundation

protocol TrackersViewModelProtocol {
    var date: Date? { get set }
    var trackersBinding: Binding<[TrackerCategory]>? {get set}
    var visibleCategories: [TrackerCategory] { get }
    func addTracker(tracker : Tracker, category : String)
    func updateTracker(tracker: Tracker, newCategory: String?)
    func deleteTracker(for id: UUID)
    func togglePinned(for id: UUID)
    func fetchTrackers()
    func category(for id: UUID) -> String?
    func filterItems (by searchText: String)
}

final class TrackersViewModel: TrackersViewModelProtocol {
    var date: Date?
    
    var trackersBinding: Binding<[TrackerCategory]>?
    
    private let trackerStore: TrackerStore = TrackerStore()
    
    private var categories: [TrackerCategory] = []
    
    private var searchText: String = ""
    
    private(set) var visibleCategories: [TrackerCategory] = [] {
        didSet {
            trackersBinding?(visibleCategories)
        }
    }
    
    init() {
        trackerStore.delegate = self
        fetchTrackers()
    }
    
    func addTracker(tracker : Tracker, category : String) {
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
    
    func fetchTrackers() {
        if let date {
            categories = trackerStore.fetchTrackers(for: date)
            filterItems(by: self.searchText)
        }
    }
    
    func category(for id: UUID) -> String? {
        return trackerStore.getTrackerCategoryTitle(by: id)
    }
    
    func filterItems(by searchText: String) {
        self.searchText = searchText
        
        if searchText.isEmpty {
            self.visibleCategories = self.categories
        } else {
            self.visibleCategories = []
            for category in categories {
                let filteredItems = category.trackers?.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                if !(filteredItems?.isEmpty ?? false) {
                    self.visibleCategories.append(TrackerCategory(title: category.title, trackers: filteredItems))
                }
            }
        }
    }
    
}

extension TrackersViewModel: StoreDelegate {
    func storeDidUpdate() {
        fetchTrackers()
    }
    
    
}
