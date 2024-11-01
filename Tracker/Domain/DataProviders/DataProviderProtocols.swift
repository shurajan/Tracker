//
//  Untitled.swift
//  Tracker
//
//  Created by Alexander Bralnin on 31.10.2024.
//
import Foundation


enum DataProviderError: Error {
    case failedToInitializeContext
}


struct IndexUpdate {
    let insertedSections: IndexSet
    let deletedSections: IndexSet
    let insertedItems: [Int: IndexSet]
    let deletedItems: [Int: IndexSet]
    let updatedItems: [Int: IndexSet]
    let movedItems: [(from: IndexPath, to: IndexPath)]
}

protocol DataProviderDelegate: AnyObject {
    func didUpdate(_ update: IndexUpdate)
    func reloadData()
    func updatePlaceholderVisibility(isHidden: Bool)
}

protocol TrackersViewDataProviderProtocol {
    var currentDate: Date { get set }
    func numberOfSections() -> Int
    func titleForSection(_ section: Int) -> String?
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at: IndexPath) -> Tracker?
    func addTracker(tracker: Tracker, category: TrackerCategory) throws
    func deleteTracker(at indexPath: IndexPath) throws
}
