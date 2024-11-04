//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.11.2024.
//
import Foundation

protocol TrackersViewModelProtocol {
    func fetchTrackers(for date: Date,completion:()->Void)
    func numberOfSections() -> Int
    func titleForSection(_ section: Int) -> String?
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at indexPath: IndexPath) -> Tracker?
}

final class TrackersViewModel: TrackersViewModelProtocol {
    private let trackerStore: TrackerStore
    private var trackerCategories: [TrackerCategory] = []
    
    init(trackerStore: TrackerStore) {
        self.trackerStore = trackerStore
    }
    
    func fetchTrackers(for date: Date, completion:()->Void) {
        trackerCategories = trackerStore.fetchTrackers(for: date)
        completion()
    }
    
    func numberOfSections() -> Int {
        return trackerCategories.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        guard section >= 0 && section < trackerCategories.count else { return nil }
        return trackerCategories[section].title
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard section >= 0 && section < trackerCategories.count else { return 0 }
        return trackerCategories[section].trackers.count
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let section = indexPath.section
        let row = indexPath.row
        guard section >= 0 && section < trackerCategories.count else { return nil }
        let trackers = trackerCategories[section].trackers
        guard row >= 0 && row < trackers.count else { return nil }
        return trackers[row]
    }
}
