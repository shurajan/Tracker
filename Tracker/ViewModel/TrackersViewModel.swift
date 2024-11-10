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
