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
    func addTracker(tracker : Tracker, category : String)
    func fetchTrackers()
    func numberOfSections() -> Int
    func titleForSection(_ section: Int) -> String?
    func numberOfRowsInSection(_ section: Int) -> Int
    func item(at indexPath: IndexPath) -> Tracker?
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
    
    func fetchTrackers() {
        if let date {
            categories = trackerStore.fetchTrackers(for: date)
            filterItems(by: self.searchText)
        }
    }
    
    func numberOfSections() -> Int {
        return visibleCategories.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        return visibleCategories[safe: section]?.title
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return visibleCategories[safe: section]?.trackers?.count ?? 0
    }
    
    func item(at indexPath: IndexPath) -> Tracker? {
        let section = indexPath.section
        let row = indexPath.row
        
        return visibleCategories[safe: section]?.trackers?[safe: row]
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
