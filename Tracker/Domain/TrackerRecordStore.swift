//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//

import CoreData

final class TrackerRecordStore: BasicStore {
    
    func addTrackerRecord(_ trackerRecord :TrackerRecord) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: self.managedObjectContext)
        trackerRecordCoreData.tracker_id = trackerRecord.trackerId
        trackerRecordCoreData.date = trackerRecord.date
    }
}
