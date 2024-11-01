//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//

import CoreData

final class TrackerRecordStore: BasicStore {
    
    func manageTrackerRecord(trackerRecord :TrackerRecord) {
        let records = getTrackerRecordCoreData(by: trackerRecord.trackerId, and: trackerRecord.date)
        
        if records.isEmpty {
            let trackerRecordCoreData = TrackerRecordCoreData(context: self.managedObjectContext)
            trackerRecordCoreData.tracker_id = trackerRecord.trackerId
            trackerRecordCoreData.date = trackerRecord.date.startOfDay()
        } else {
            for record in records {
                managedObjectContext.delete(record)
            }
        }
    }
    
    func count(by id: UUID) -> Int {
        let recordFetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
        recordFetchRequest.predicate = NSPredicate(format: "tracker_id == %@", id as CVarArg)
        recordFetchRequest.resultType = .countResultType
        
        do {
            let count = try managedObjectContext.count(for: recordFetchRequest)
            return count
        } catch {
            Log.error(error: error)
            return 0
        }
    }
    
    func exist(trackerRecord :TrackerRecord) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
        let searchDate = trackerRecord.date.startOfDay() as NSDate
        let id = trackerRecord.trackerId as CVarArg
        fetchRequest.predicate = NSPredicate(format: "tracker_id == %@ AND date == %@", id as CVarArg, searchDate)
        fetchRequest.resultType = .countResultType
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try managedObjectContext.count(for: fetchRequest)
            return count > 0
        } catch {
            Log.error(error: error)
            return false
        }
    }
    
    private func getTrackerRecordCoreData(by id: UUID) -> [TrackerRecordCoreData] {
        let recordFetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        recordFetchRequest.predicate = NSPredicate(format: "tracker_id == %@", id as CVarArg)
        
        do {
            let fetchedRecords = try managedObjectContext.fetch(recordFetchRequest)
            return fetchedRecords
        } catch {
            Log.error(error: error)
            return []
        }
    }
    
    private func getTrackerRecordCoreData(by id: UUID, and date: Date) -> [TrackerRecordCoreData] {
        let recordFetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        let dateStart = Calendar.current.startOfDay(for: date) as NSDate
        recordFetchRequest.predicate = NSPredicate(format: "tracker_id == %@ AND date == %@", id as CVarArg, dateStart)
        
        do {
            let fetchedRecords = try managedObjectContext.fetch(recordFetchRequest)
            return fetchedRecords
        } catch {
            Log.error(error: error)
            return []
        }
    }
    
}
