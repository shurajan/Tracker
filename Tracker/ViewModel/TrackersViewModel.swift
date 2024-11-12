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
    func object(at indexPath: IndexPath) -> Tracker?
}

final class TrackersViewModel: TrackersViewModelProtocol {
    
    var date: Date?
    
    var trackersBinding: Binding<[TrackerCategory]>?
    
    private let trackerStore: TrackerStore = TrackerStore()
    
    private(set) var trackerCategories: [TrackerCategory] = [] {
        didSet {
            trackersBinding?(trackerCategories)
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
            trackerCategories = trackerStore.fetchTrackers(for: date)
        }
    }
    
    func numberOfSections() -> Int {
        return trackerCategories.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        return trackerCategories[safe: section]?.title
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return trackerCategories[safe: section]?.trackers?.count ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let section = indexPath.section
        let row = indexPath.row
        
        return trackerCategories[safe: section]?.trackers?[safe: row]
        
    }
}

extension TrackersViewModel: StoreDelegate {
    func storeDidUpdate() {
        fetchTrackers()
    }
    
    
}
