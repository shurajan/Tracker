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


protocol TrackersViewModelProtocol {
    var currentDate: Date { get }
    var onDataUpdate: ((_ update: IndexUpdate)->Void)? { get set }
    func setCurrentDate(new date: Date, completion:()->Void)
    func numberOfSections() -> Int
    func titleForSection(_ section: Int) -> String?
    func numberOfRowsInSection(_ section: Int) -> Int
    func addTracker(tracker: Tracker, category: TrackerCategory) throws
    func findTracker(at: IndexPath) -> Tracker?
}

protocol TrackerRecordDataProviderProtocol {
    func manageTrackerRecord(trackerRecord :TrackerRecord)
    func count(trackerRecord: TrackerRecord) -> Int
    func exist(trackerRecord: TrackerRecord) -> Bool
}
